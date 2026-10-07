<?php

class SearchController extends ControllerBase
{

    public function indexAction()
    {
        $headerCollection = $this->assets->collection('header');
        $headerCollection->addCss('https://cdn.jsdelivr.net/npm/swiper/swiper-bundle.min.css');
        $headerCollection->addCss('https://cdn.jsdelivr.net/npm/@fancyapps/ui@5.0/dist/fancybox/fancybox.css');
		$headerCollection->addCss('css/navbar.css');
		$headerCollection->addCss('css/custom.css');


        $footerCollection = $this->assets->collection('footer');
        $footerCollection->addJs('https://cdn.jsdelivr.net/npm/swiper/swiper-bundle.min.js');
        $footerCollection->addJs('https://cdn.jsdelivr.net/npm/@fancyapps/ui@5.0/dist/fancybox/fancybox.umd.js'); 
        $footerCollection->addJs('https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js');
        $footerCollection->addJs('https://cdn.jsdelivr.net/npm/nouislider@15.7.0/dist/nouislider.min.js');

        $limit = 8;  // Jumlah data per halaman
        $currentPage = (int) $this->dispatcher->getParam('page', 'int', 1);
        if ($currentPage < 1) {
            $currentPage = 1;
        }
        $offset = ($currentPage - 1) * $limit;

        $search_url = str_replace("-"," ",$this->dispatcher->getParam('search_url'));
        $decoded_url = htmlspecialchars(urldecode($search_url));
        $this->tag->setTitle('Search result for '.$decoded_url);
        $this->view->setVar('decoded_url',$decoded_url);

        if($this->session->has('areas') != 1){
			$this->session->set('areas', [
				'default' => 'bali',
				'selected' => 'bali'
			]);
		}

        $areaSlug = $this->session->get('areas')['selected'];
        $productAreaIds = [];

        if ($areaSlug) {
            $area = Areas::findFirst([
                'conditions' => 'area_url = :slug:',
                'bind' => ['slug' => $areaSlug]
            ]);

            if ($area) {
                $parentId = $area->id_area;

                $subAreas = Areas::find([
                    'conditions' => 'area_parent = :parent:',
                    'bind' => ['parent' => $parentId]
                ]);

                $areaIds = [$parentId];
                foreach ($subAreas as $sub) {
                    $areaIds[] = $sub->id_area;
                }

                $areaProducts = Areas_products::find([
                    'conditions' => 'id_area IN ({ids:array})',
                    'bind' => ['ids' => $areaIds]
                ]);

                foreach ($areaProducts as $ap) {
                    $productAreaIds[] = $ap->id_product;
                }
            }
        }
                //search data
                $productFilter = '';
        if (!empty($productAreaIds)) {
            $idList = implode(',', $productAreaIds);
            $productFilter = " AND p.id IN ($idList)";
        }

        if (!empty($productFilter)) {
        $q = "SELECT p.id, p.name, p.slug, p.description, p.page_title, p.provider, p.ordered,
                opt.id AS id_rate_options, opt.rate_option_price, 
                ra.publish_price AS price, p.group_product, 
                (SELECT f.name FROM Upload_file_morph uf 
                LEFT JOIN Upload_file f ON f.id = uf.upload_file_id 
                WHERE uf.related_type = 'products' 
                AND uf.related_id = p.id ORDER BY f.id LIMIT 1) as picture, 
                (SELECT SUM(r.review_star)/COUNT(r.id) 
                FROM Product_reviews r 
                WHERE r.product_id = p.id) as review 
            FROM Products p 
            LEFT JOIN Rates r ON r.product = p.id 
            LEFT JOIN Rate_options opt ON opt.id_rate = r.id 
            LEFT JOIN Rate_availability ra ON ra.id_rate_opt = opt.id 
            WHERE p.product_status = 1
            AND p.name LIKE '%".$decoded_url."%' 
            $productFilter 
            AND EXISTS (
            SELECT 1 FROM Rates r2
            JOIN Rate_options ro2 ON ro2.id_rate = r2.id
            JOIN Rate_availability ra2 ON ra2.id_rate_opt = ro2.id
            WHERE r2.product = p.id AND ra2.publish_price > 0
            )
            GROUP BY p.id 
            LIMIT " . intval($limit) . " OFFSET " . intval($offset);


        $row = $this->modelsManager->executeQuery($q, [
            'search' => '%' . $decoded_url . '%'
        ]);
            } else {
                $row = []; 
            }
                // die($q);

                $productFilterCount = '';
                if (!empty($productAreaIds)) {
                    $idList = implode(',', $productAreaIds);
                    $productFilterCount = " AND p.id IN ($idList)";
                }


                $countQuery = "SELECT COUNT(*) AS total 
                            FROM Products p 
                            WHERE p.product_status = 1 
                            AND p.name LIKE :search:
                            AND EXISTS (
                            SELECT 1 FROM Rates r2
                            JOIN Rate_options ro2 ON ro2.id_rate = r2.id
                            JOIN Rate_availability ra2 ON ra2.id_rate_opt = ro2.id
                            WHERE r2.product = p.id AND ra2.publish_price > 0
                            )
                            $productFilterCount";

                $totalResults = $this->modelsManager->executeQuery($countQuery, [
                    'search' => '%' . $decoded_url . '%'
                ])->getFirst()->total;
                $totalPages = ceil($totalResults / $limit);

                $arrdata = [];
                $reviewStats = [];
                foreach ($row as $key => $val) {
            $productId = $val['id'];

            // --- Ambil publish_price terendah ---
            $minPriceQuery = "SELECT MIN(ra.publish_price) AS min_price
                            FROM Rates r
                            JOIN Rate_options ro ON ro.id_rate = r.id
                            JOIN Rate_availability ra ON ra.id_rate_opt = ro.id
                            WHERE r.product = :product_id: AND ra.publish_price > 0";
            $minPriceResult = $this->modelsManager->executeQuery($minPriceQuery, [
                'product_id' => $productId
            ]);
            $minPublishPrice = $minPriceResult[0]['min_price'] ?? 0;

            $discounted_price = $minPublishPrice;

            // --- Hitung diskon dari Hotdeal (jika ada) ---
            if (!empty($val['id_rate_options'])) {
                $rateOptionQuery = "SELECT ro.id
                    FROM Rates r
                    JOIN Rate_options ro ON ro.id_rate = r.id
                    JOIN Rate_availability ra ON ra.id_rate_opt = ro.id
                    WHERE r.product = :product_id: AND ra.publish_price = :min_price:
                    LIMIT 1";

                $rateOpt = $this->modelsManager->executeQuery($rateOptionQuery, [
                    'product_id' => $val->id,
                    'min_price' => $minPublishPrice
                ])->getFirst();

                if ($rateOpt) {
                    $q3 = "SELECT h.hotdeal_type, h.hotdeal_value, promo_status 
                        FROM Hotdeals h 
                        WHERE FIND_IN_SET(:rate_option_id:, h.rates) > 0";
                    $hotdeals = $this->modelsManager->executeQuery($q3, [
                        'rate_option_id' => (string) $rateOpt->id 
                    ]);

                    if (count($hotdeals) > 0) {
                        foreach ($hotdeals as $hotdeal) {
                            if ($hotdeal->promo_status == 1) {
                                if ($hotdeal->hotdeal_type == 1) {
                                    $discounted_price -= $hotdeal->hotdeal_value;
                                } else {
                                    $discounted_price -= ($minPublishPrice * ($hotdeal->hotdeal_value / 100));
                                }
                            } else {
                                $discounted_price = 0;
                            }
                        }
                    } else {
                        $discounted_price = 0;
                    }
                } else {
                    $discounted_price = 0;
                }
            } else {
                $discounted_price = 0;
            }

            $arrdata[$productId] = [
                'rate_option_price' => $minPublishPrice,
                'discounted_price' => max($discounted_price, 0),
                'min_publish_price' => $minPublishPrice,
            ];

            $qr = "SELECT rev.id, rev.parent_id, rev.product_id, rev.review_star, rev.review_comment, rev.review_name, rev.review_country, rev.created_at FROM Product_reviews rev WHERE product_id = '".$val['id']."' AND parent_id = 0 ORDER BY rev.created_at DESC";
            $rev = $this->modelsManager->executeQuery($qr);

            $reviewer = Product_reviews::count([
                'conditions' => 'product_id = :id: AND parent_id = 0',
                'bind' => [
                    'id' => $val['id'],
                ],
            ]);

            $totalStars = 0;
            $totalReviews = $reviewer;

            if ($totalReviews > 0) {
                foreach ($rev as $r) {
                    $totalStars += $r->review_star;
                }
                $averageRating = round($totalStars / $totalReviews, 1);
            } else {
                // Fallback: review dari semua produk milik provider yang sama
                $providerId = $val['provider'];

                $providerProducts = Products::find([
                    'conditions' => 'provider = :provider_id:',
                    'bind' => ['provider_id' => $providerId],
                    'columns' => 'id'
                ]);

                $providerProductIds = [];
                foreach ($providerProducts as $prod) {
                    $providerProductIds[] = $prod->id;
                }

                if (!empty($providerProductIds)) {
                    $qFallback = "SELECT review_star FROM Product_reviews WHERE product_id IN ({ids:array})";
                    $fallbackReviews = $this->modelsManager->executeQuery($qFallback, [
                        'ids' => $providerProductIds
                    ]);

                    $totalFallbackStars = 0;
                    $totalFallbackReviews = count($fallbackReviews);

                    if ($totalFallbackReviews > 0) {
                        foreach ($fallbackReviews as $fr) {
                            $totalFallbackStars += $fr->review_star;
                        }
                        $averageRating = round($totalFallbackStars / $totalFallbackReviews, 1);
                        $totalReviews = $totalFallbackReviews;
                    } else {
                        $averageRating = 0;
                        $totalReviews = 0;
                    }
                } else {
                    $averageRating = 0;
                    $totalReviews = 0;
                }
            }

            // Simpan data rating
            $reviewStats[$productId] = [
                'total_review'   => $totalReviews,
                'average_rating' => $averageRating,
                'is_provider'    => ($reviewer == 0) ? true : false
            ];
        }

        
        $this->view->setVars([
            'search_result' => $row,
            'total_results' => $totalResults,
            'currentPage' => $currentPage,
            'hotdeals' => $arrdata,
            'reviewStats' => $reviewStats,
            'totalPages' => $totalPages
        ]);

        $this->view->pick('search/index');

        $footerCollection = $this->assets->collection('footer');
        $footerCollection->addJs('js/index.js');
    }

// 	public function searchareaAction()
// {
//     // Asset setup
//     $headerCollection = $this->assets->collection('header');
//     $headerCollection->addCss('https://cdn.jsdelivr.net/npm/swiper/swiper-bundle.min.css');
//     $headerCollection->addCss('https://cdn.jsdelivr.net/npm/glightbox@3.0.7/dist/css/glightbox.min.css');
//     $headerCollection->addCss('css/navbar.css');

//     $footerCollection = $this->assets->collection('footer');
//     $footerCollection->addJs('https://cdn.jsdelivr.net/npm/swiper/swiper-bundle.min.js');
//     $footerCollection->addJs('https://cdn.jsdelivr.net/npm/glightbox@3.0.7/dist/js/glightbox.min.js');
//     $footerCollection->addJs('https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js');
//     $footerCollection->addJs('https://cdn.jsdelivr.net/npm/nouislider@15.7.0/dist/nouislider.min.js');

//     $limit = 8;
//     $currentPage = (int) $this->dispatcher->getParam('page', 'int', 1);
//     if ($currentPage < 1) $currentPage = 1;
//     $offset = ($currentPage - 1) * $limit;

//     // Ambil parameter dari URL
//     $search_url = str_replace("-", " ", $this->dispatcher->getParam('search_url'));
//     $decoded_url = htmlspecialchars(urldecode($search_url));
//     $areaUrl = $this->dispatcher->getParam('area');

//     // Ambil area utama
//     $mainArea = Areas::findFirst([
//         'conditions' => 'area_url = :area: AND area_status = 1',
//         'bind' => ['area' => $areaUrl]
//     ]);

//     if (!$mainArea) {
//         return $this->response->redirect('/');
//     }

//     $this->tag->setTitle('Search result for "' . $decoded_url . '" in ' . $mainArea->area_name);
//     $this->view->setVar('decoded_url', $decoded_url);

//     // Cari subarea yang punya produk sesuai keyword
//     $sql = "SELECT ar.id_area, ar.iso2, ar.area_parent, ar.area_name, ar.area_url, ar.area_status, ar.area_description, ar.area_view,
//         (
//             SELECT f.name 
//             FROM Upload_file_morph uf 
//             LEFT JOIN Upload_file f ON f.id = uf.upload_file_id 
//             WHERE uf.related_type = 'areas' AND uf.related_id = ar.id_area 
//             LIMIT 1
//         ) as picture
//         FROM Areas ar
//         WHERE ar.area_parent = :parent_id:
//         AND ar.area_status = 1
//         AND EXISTS (
//             SELECT 1 FROM Areas_products ap
//             JOIN Products p ON p.id = ap.id_product
//             WHERE ap.id_area = ar.id_area
//             AND p.name LIKE :keyword:
//         )
//         ORDER BY ar.area_name ASC
//         LIMIT $limit OFFSET $offset
//     ";

//     $subareas = $this->modelsManager->executeQuery($sql, [
//         'parent_id' => $mainArea->id_area,
//         'keyword' => '%' . $decoded_url . '%'
//     ]);

//     // Hitung total subarea hasil pencarian
//     $countQuery = "SELECT COUNT(*) as total
//         FROM Areas ar
//         WHERE ar.area_parent = :parent_id:
//         AND ar.area_status = 1
//         AND EXISTS (
//             SELECT 1 FROM Areas_products ap
//             JOIN Products p ON p.id = ap.id_product
//             WHERE ap.id_area = ar.id_area
//             AND p.name LIKE :keyword:
//         )
//     ";

//     $totalResults = $this->modelsManager->executeQuery($countQuery, [
//         'parent_id' => $mainArea->id_area,
//         'keyword' => '%' . $decoded_url . '%'
//     ])->getFirst()->total;

//     $totalPages = ceil($totalResults / $limit);

//     // (Opsional) bisa ambil juga produk yang cocok buat display di halaman ini
//     // atau langsung tampilkan jumlah produk per subarea kalau kamu mau.

//     $this->view->setVars([
//         'area' => $mainArea,
//         'subarea' => $subareas,
//         'total_results' => $totalResults,
//         'currentPage' => $currentPage,
//         'totalPages' => $totalPages,
//         'parent' => $parent
//     ]);

//     $this->view->pick('areas/search');

//     $footerCollection->addJs('js/index.js');
// }

    public function searchcategoryAction(){

        $headerCollection = $this->assets->collection('header');
        $headerCollection->addCss('https://cdn.jsdelivr.net/npm/swiper/swiper-bundle.min.css');
        $headerCollection->addCss('https://cdn.jsdelivr.net/npm/@fancyapps/ui@5.0/dist/fancybox/fancybox.css');
		$headerCollection->addCss('css/navbar.css');
		$headerCollection->addCss('css/custom.css');


        $footerCollection = $this->assets->collection('footer');
        $footerCollection->addJs('https://cdn.jsdelivr.net/npm/swiper/swiper-bundle.min.js');
        $footerCollection->addJs('https://cdn.jsdelivr.net/npm/@fancyapps/ui@5.0/dist/fancybox/fancybox.umd.js'); 
        $footerCollection->addJs('https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js');
        $footerCollection->addJs('https://cdn.jsdelivr.net/npm/nouislider@15.7.0/dist/nouislider.min.js');

        $limit = 8;  // Jumlah data per halaman
        $currentPage = (int) $this->dispatcher->getParam('page', 'int', 1);
        if ($currentPage < 1) {
            $currentPage = 1;
        }
        $offset = ($currentPage - 1) * $limit;

        $search_url = str_replace("-"," ",$this->dispatcher->getParam('search_url'));
        $groupProduct = str_replace("-"," ",$this->dispatcher->getParam('category_url'));
        $decoded_url = htmlspecialchars(urldecode($search_url));
        $this->tag->setTitle('Search result for '.$decoded_url);
        $this->view->setVar('decoded_url',$decoded_url);

        if($this->session->has('areas') != 1){
			$this->session->set('areas', [
				'default' => 'bali',
				'selected' => 'bali'
			]);
		}

        $areaSlug = $this->session->get('areas')['selected'];
        $productAreaIds = [];

        if ($areaSlug) {
            $area = Areas::findFirst([
                'conditions' => 'area_url = :slug:',
                'bind' => ['slug' => $areaSlug]
            ]);

            if ($area) {
                $parentId = $area->id_area;

                $subAreas = Areas::find([
                    'conditions' => 'area_parent = :parent:',
                    'bind' => ['parent' => $parentId]
                ]);

                $areaIds = [$parentId];
                foreach ($subAreas as $sub) {
                    $areaIds[] = $sub->id_area;
                }

                $areaProducts = Areas_products::find([
                    'conditions' => 'id_area IN ({ids:array})',
                    'bind' => ['ids' => $areaIds]
                ]);

                foreach ($areaProducts as $ap) {
                    $productAreaIds[] = $ap->id_product;
                }
            }
        }
                //search data
                $productFilter = '';
        if (!empty($productAreaIds)) {
            $idList = implode(',', $productAreaIds);
            $productFilter = " AND p.id IN ($idList)";
        }

        if (!empty($productFilter)) {
        $q = "SELECT p.id, p.name, p.slug, p.description, p.page_title, p.provider, p.ordered,
                opt.id AS id_rate_options, opt.rate_option_price, 
                ra.publish_price AS price, p.group_product, 
                (SELECT f.name FROM Upload_file_morph uf 
                LEFT JOIN Upload_file f ON f.id = uf.upload_file_id 
                WHERE uf.related_type = 'products' 
                AND uf.related_id = p.id ORDER BY f.id LIMIT 1) as picture, 
                (SELECT SUM(r.review_star)/COUNT(r.id) 
                FROM Product_reviews r 
                WHERE r.product_id = p.id) as review 
            FROM Products p 
            LEFT JOIN Rates r ON r.product = p.id 
            LEFT JOIN Rate_options opt ON opt.id_rate = r.id 
            LEFT JOIN Rate_availability ra ON ra.id_rate_opt = opt.id 
            WHERE p.product_status = 1 
            AND p.name LIKE '%".$decoded_url."%' AND p.group_product = '".$groupProduct."'
            $productFilter 
            AND EXISTS (
            SELECT 1 FROM Rates r2
            JOIN Rate_options ro2 ON ro2.id_rate = r2.id
            JOIN Rate_availability ra2 ON ra2.id_rate_opt = ro2.id
            WHERE r2.product = p.id AND ra2.publish_price > 0
            )
            GROUP BY p.id 
            LIMIT " . intval($limit) . " OFFSET " . intval($offset);


        $row = $this->modelsManager->executeQuery($q, [
            'search' => '%' . $decoded_url . '%'
        ]);
            } else {
                $row = []; 
            }
                // die($q);

                $productFilterCount = '';
                if (!empty($productAreaIds)) {
                    $idList = implode(',', $productAreaIds);
                    $productFilterCount = " AND p.id IN ($idList)";
                }


                $countQuery = "SELECT COUNT(*) AS total 
                            FROM Products p 
                            WHERE p.product_status = 1 
                            AND p.name LIKE :search: AND p.group_product = '".$groupProduct."'
                            $productFilterCount 
                            AND EXISTS (
                            SELECT 1 FROM Rates r2
                            JOIN Rate_options ro2 ON ro2.id_rate = r2.id
                            JOIN Rate_availability ra2 ON ra2.id_rate_opt = ro2.id
                            WHERE r2.product = p.id AND ra2.publish_price > 0
                            )";

                $totalResults = $this->modelsManager->executeQuery($countQuery, [
                    'search' => '%' . $decoded_url . '%'
                ])->getFirst()->total;
                $totalPages = ceil($totalResults / $limit);

                $arrdata = [];
                $reviewStats = [];
                foreach ($row as $key => $val) {
            $productId = $val->id;

            // --- Ambil publish_price terendah ---
            $minPriceQuery = "SELECT MIN(ra.publish_price) AS min_price
                            FROM Rates r
                            JOIN Rate_options ro ON ro.id_rate = r.id
                            JOIN Rate_availability ra ON ra.id_rate_opt = ro.id
                            WHERE r.product = :product_id: AND ra.publish_price > 0";
            $minPriceResult = $this->modelsManager->executeQuery($minPriceQuery, [
                'product_id' => $productId
            ]);
            $minPublishPrice = $minPriceResult[0]['min_price'] ?? 0;

            $discounted_price = $minPublishPrice;

            // --- Hitung diskon dari Hotdeal (jika ada) ---
            if (!empty($val->id_rate_options)) {
                $rateOptionQuery = "SELECT ro.id
                    FROM Rates r
                    JOIN Rate_options ro ON ro.id_rate = r.id
                    JOIN Rate_availability ra ON ra.id_rate_opt = ro.id
                    WHERE r.product = :product_id: AND ra.publish_price = :min_price:
                    LIMIT 1";

                $rateOpt = $this->modelsManager->executeQuery($rateOptionQuery, [
                    'product_id' => $val->id,
                    'min_price' => $minPublishPrice
                ])->getFirst();

                if ($rateOpt) {
                    $q3 = "SELECT h.hotdeal_type, h.hotdeal_value, promo_status 
                        FROM Hotdeals h 
                        WHERE FIND_IN_SET(:rate_option_id:, h.rates) > 0";
                    $hotdeals = $this->modelsManager->executeQuery($q3, [
                        'rate_option_id' => (string) $rateOpt->id
                    ]);

                    if (count($hotdeals) > 0) {
                        foreach ($hotdeals as $hotdeal) {
                            if ($hotdeal->promo_status == 1) {
                                if ($hotdeal->hotdeal_type == 1) {
                                    $discounted_price -= $hotdeal->hotdeal_value;
                                } else {
                                    $discounted_price -= ($minPublishPrice * ($hotdeal->hotdeal_value / 100));
                                }
                            } else {
                                $discounted_price = 0;
                            }
                        }
                    } else {
                        $discounted_price = 0;
                    }
                } else {
                    $discounted_price = 0;
                }
            } else {
                $discounted_price = 0;
            }

            $arrdata[$productId] = [
                'rate_option_price' => $minPublishPrice,
                'discounted_price' => max($discounted_price, 0),
                'min_publish_price' => $minPublishPrice
            ];

            // --- Ambil review utama produk ---
            $qr = "SELECT rev.id, rev.parent_id, rev.product_id, rev.review_star, rev.review_comment, rev.review_name, rev.review_country, rev.created_at FROM Product_reviews rev WHERE product_id = '".$val['id']."' AND parent_id = 0 ORDER BY rev.created_at DESC";
        $rev = $this->modelsManager->executeQuery($qr);

        $reviewer = Product_reviews::count([
            'conditions' => 'product_id = :id: AND parent_id = 0',
            'bind' => [
                'id' => $val['id'],
            ],
        ]);

        $totalStars = 0;
        $totalReviews = $reviewer;

        if ($totalReviews > 0) {
            foreach ($rev as $r) {
                $totalStars += $r->review_star;
            }
            $averageRating = round($totalStars / $totalReviews, 1);
        } else {
            // Fallback: review dari semua produk milik provider yang sama
            $providerId = $val['provider'];

            $providerProducts = Products::find([
                'conditions' => 'provider = :provider_id:',
                'bind' => ['provider_id' => $providerId],
                'columns' => 'id'
            ]);

            $providerProductIds = [];
            foreach ($providerProducts as $prod) {
                $providerProductIds[] = $prod->id;
            }

            if (!empty($providerProductIds)) {
                $qFallback = "SELECT review_star FROM Product_reviews WHERE product_id IN ({ids:array}) AND parent_id = 0";
                $fallbackReviews = $this->modelsManager->executeQuery($qFallback, [
                    'ids' => $providerProductIds
                ]);

                $totalFallbackStars = 0;
                $totalFallbackReviews = count($fallbackReviews);

                if ($totalFallbackReviews > 0) {
                    foreach ($fallbackReviews as $fr) {
                        $totalFallbackStars += $fr->review_star;
                    }
                    $averageRating = round($totalFallbackStars / $totalFallbackReviews, 1);
                    $totalReviews = $totalFallbackReviews;
                } else {
                    $averageRating = 0;
                    $totalReviews = 0;
                }
            } else {
                $averageRating = 0;
                $totalReviews = 0;
            }
        }

            // Simpan data rating
            $reviewStats[$productId] = [
                'total_review'   => $totalReviews,
                'average_rating' => $averageRating,
                'is_provider'    => ($reviewer == 0) ? true : false
            ];
        }

        
        $this->view->setVars([
            'search_result' => $row,
            'total_results' => $totalResults,
            'currentPage' => $currentPage,
            'hotdeals' => $arrdata,
            'reviewStats' => $reviewStats,
            'totalPages' => $totalPages,
            'category_url' => $this->dispatcher->getParam('category_url'),
            'search_url' => $this->dispatcher->getParam('search_url')
        ]);

        $this->view->pick('search/index');

        $footerCollection = $this->assets->collection('footer');
        $footerCollection->addJs('js/index.js');
    
    }

    public function searchareaAction()
{
    $headerCollection = $this->assets->collection('header');
    $headerCollection->addCss('https://cdn.jsdelivr.net/npm/swiper/swiper-bundle.min.css');
    $headerCollection->addCss('https://cdn.jsdelivr.net/npm/glightbox@3.0.7/dist/css/glightbox.min.css');
    $headerCollection->addCss('css/navbar.css');

    $footerCollection = $this->assets->collection('footer');
    $footerCollection->addJs('https://cdn.jsdelivr.net/npm/swiper/swiper-bundle.min.js');
    $footerCollection->addJs('https://cdn.jsdelivr.net/npm/glightbox@3.0.7/dist/js/glightbox.min.js');
    $footerCollection->addJs('https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js');
    $footerCollection->addJs('https://cdn.jsdelivr.net/npm/nouislider@15.7.0/dist/nouislider.min.js');
    $footerCollection->addJs('js/index.js');

    $limit = 8;
    $currentPage = (int) $this->dispatcher->getParam('page', 'int', 1);
    if ($currentPage < 1) $currentPage = 1;
    $offset = ($currentPage - 1) * $limit;

    $search_url = str_replace("-", " ", $this->dispatcher->getParam('search_url'));
    $decoded_url = htmlspecialchars(urldecode($search_url));

    $areaUrl = $this->dispatcher->getParam('area');
    $subareaUrl = $this->dispatcher->getParam('subarea');

    $mainArea = Areas::findFirst([
        'conditions' => 'area_url = :area: AND area_status = 1',
        'bind' => ['area' => $areaUrl]
    ]);

    $subarea = Areas::findFirst([
        'conditions' => 'area_url = :sub: AND area_status = 1',
        'bind' => ['sub' => $subareaUrl]
    ]);

    if (!$mainArea || !$subarea) {
        return $this->response->redirect('/');
    }

    $this->tag->setTitle('Search result for "' . $decoded_url . '" in ' . $subarea->area_name);
    $this->view->setVar('decoded_url', $decoded_url);

    // Ambil ID produk yang sesuai area
    $areaProducts = Areas_products::find([
        'conditions' => 'id_area = :id:',
        'bind' => ['id' => $subarea->id_area],
        'columns' => 'id_product'
    ]);

    $productIds = array_column($areaProducts->toArray(), 'id_product');
    // print_r($productIds);die();

    $products = [];
    $totalResults = 0;

    if (!empty($productIds)) {
        $idsString = implode(',', $productIds);

        $sql = "SELECT p.id, p.name, p.slug, p.page_title, p.description, p.group_product, p.provider, p.ordered,
                    f.name AS picture
                FROM Products p
                LEFT JOIN Upload_file_morph uf ON uf.related_id = p.id AND uf.related_type = 'products'
                LEFT JOIN Upload_file f ON f.id = uf.upload_file_id
                WHERE p.id IN ($idsString)
                AND p.product_status = 1
                AND p.name LIKE :keyword:
                AND EXISTS (
                SELECT 1 FROM Rates r2
                JOIN Rate_options ro2 ON ro2.id_rate = r2.id
                JOIN Rate_availability ra2 ON ra2.id_rate_opt = ro2.id
                WHERE r2.product = p.id AND ra2.publish_price > 0
                )
                GROUP BY p.id
                ORDER BY p.id DESC
                LIMIT $limit OFFSET $offset";

        $products = $this->modelsManager->executeQuery($sql, [
            'keyword' => '%' . $decoded_url . '%'
        ]);

        // Total count
        $countQuery = "SELECT COUNT(*) AS total
                FROM Products p
                WHERE p.id IN ($idsString)
                AND p.product_status = 1
                AND p.name LIKE :keyword:
                AND EXISTS (
                SELECT 1 FROM Rates r2
                JOIN Rate_options ro2 ON ro2.id_rate = r2.id
                JOIN Rate_availability ra2 ON ra2.id_rate_opt = ro2.id
                WHERE r2.product = p.id AND ra2.publish_price > 0
                )";

        $totalResults = $this->modelsManager->executeQuery($countQuery, [
            'keyword' => '%' . $decoded_url . '%'
        ])->getFirst()->total;

        $totalPages = ceil($totalResults / $limit);

                $arrdata = [];
                $reviewStats = [];
                foreach ($products as $key => $val) {
            $productId = $val->id;

            // --- Ambil publish_price terendah ---
            $minPriceQuery = "SELECT MIN(ra.publish_price) AS min_price
                            FROM Rates r
                            JOIN Rate_options ro ON ro.id_rate = r.id
                            JOIN Rate_availability ra ON ra.id_rate_opt = ro.id
                            WHERE r.product = :product_id: AND ra.publish_price > 0";
            $minPriceResult = $this->modelsManager->executeQuery($minPriceQuery, [
                'product_id' => $productId
            ]);
            $minPublishPrice = $minPriceResult[0]['min_price'] ?? 0;

            $discounted_price = $minPublishPrice;

            // --- Hitung diskon dari Hotdeal (jika ada) ---
            if (!empty($val->id_rate_options)) {
                $rateOptionQuery = "SELECT ro.id
                    FROM Rates r
                    JOIN Rate_options ro ON ro.id_rate = r.id
                    JOIN Rate_availability ra ON ra.id_rate_opt = ro.id
                    WHERE r.product = :product_id: AND ra.publish_price = :min_price:
                    LIMIT 1";

                $rateOpt = $this->modelsManager->executeQuery($rateOptionQuery, [
                    'product_id' => $val->id,
                    'min_price' => $minPublishPrice
                ])->getFirst();

                if ($rateOpt) {
                    $q3 = "SELECT h.hotdeal_type, h.hotdeal_value, promo_status 
                        FROM Hotdeals h 
                        WHERE FIND_IN_SET(:rate_option_id:, h.rates) > 0";
                    $hotdeals = $this->modelsManager->executeQuery($q3, [
                        'rate_option_id' => (string) $rateOpt->id
                    ]);

                    if (count($hotdeals) > 0) {
                        foreach ($hotdeals as $hotdeal) {
                            if ($hotdeal->promo_status == 1) {
                                if ($hotdeal->hotdeal_type == 1) {
                                    $discounted_price -= $hotdeal->hotdeal_value;
                                } else {
                                    $discounted_price -= ($minPublishPrice * ($hotdeal->hotdeal_value / 100));
                                }
                            } else {
                                $discounted_price = 0;
                            }
                        }
                    } else {
                        $discounted_price = 0;
                    }
                } else {
                    $discounted_price = 0;
                }
            } else {
                $discounted_price = 0;
            }

            $arrdata[$productId] = [
                'rate_option_price' => $minPublishPrice,
                'discounted_price' => max($discounted_price, 0),
                'min_publish_price' => $minPublishPrice
            ];

            // --- Ambil review utama produk ---
            $qr = "SELECT rev.id, rev.parent_id, rev.product_id, rev.review_star, rev.review_comment, rev.review_name, rev.review_country, rev.created_at FROM Product_reviews rev WHERE product_id = '".$val['id']."' AND parent_id = 0 ORDER BY rev.created_at DESC";
        $rev = $this->modelsManager->executeQuery($qr);

        $reviewer = Product_reviews::count([
            'conditions' => 'product_id = :id: AND parent_id = 0',
            'bind' => [
                'id' => $val['id'],
            ],
        ]);

        $totalStars = 0;
        $totalReviews = $reviewer;

        if ($totalReviews > 0) {
            foreach ($rev as $r) {
                $totalStars += $r->review_star;
            }
            $averageRating = round($totalStars / $totalReviews, 1);
        } else {
            // Fallback: review dari semua produk milik provider yang sama
            $providerId = $val['provider'];

            $providerProducts = Products::find([
                'conditions' => 'provider = :provider_id:',
                'bind' => ['provider_id' => $providerId],
                'columns' => 'id'
            ]);

            $providerProductIds = [];
            foreach ($providerProducts as $prod) {
                $providerProductIds[] = $prod->id;
            }

            if (!empty($providerProductIds)) {
                $qFallback = "SELECT review_star FROM Product_reviews WHERE product_id IN ({ids:array}) AND parent_id = 0";
                $fallbackReviews = $this->modelsManager->executeQuery($qFallback, [
                    'ids' => $providerProductIds
                ]);

                $totalFallbackStars = 0;
                $totalFallbackReviews = count($fallbackReviews);

                if ($totalFallbackReviews > 0) {
                    foreach ($fallbackReviews as $fr) {
                        $totalFallbackStars += $fr->review_star;
                    }
                    $averageRating = round($totalFallbackStars / $totalFallbackReviews, 1);
                    $totalReviews = $totalFallbackReviews;
                } else {
                    $averageRating = 0;
                    $totalReviews = 0;
                }
            } else {
                $averageRating = 0;
                $totalReviews = 0;
            }
        }

            // Simpan data rating
            $reviewStats[$productId] = [
                'total_review'   => $totalReviews,
                'average_rating' => $averageRating,
                'is_provider'    => ($reviewer == 0) ? true : false
            ];
        }
    } else {
        $products = [];
    }
    

    $totalPages = ceil($totalResults / $limit);

    $this->view->setVars([
        'area' => $mainArea,
        'subarea' => $subarea,
        'products' => $products,
        'total_results' => $totalResults,
        'currentPage' => $currentPage,
        'totalPages' => $totalPages,
        'hotdeals' => $arrdata,
        'reviewStats' => $reviewStats,
        'keyword' => $decoded_url
    ]);

    $this->view->pick('search/searchareas');
}

}

