<?php
class AreaController extends ControllerBase
{
    public function indexAction(){
        $headerCollection = $this->assets->collection('header');
        $headerCollection->addCss('https://cdn.jsdelivr.net/npm/swiper/swiper-bundle.min.css');
        $headerCollection->addCss('https://cdn.jsdelivr.net/npm/glightbox@3.0.7/dist/css/glightbox.min.css');
        $headerCollection->addCss('css/custom.css');
        $headerCollection->addCss('css/navbar.css');

        $footerCollection = $this->assets->collection('footer');
        $footerCollection->addJs('https://cdn.jsdelivr.net/npm/swiper/swiper-bundle.min.js');
        $footerCollection->addJs('https://cdn.jsdelivr.net/npm/glightbox@3.0.7/dist/js/glightbox.min.js');
        $footerCollection->addJs('https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js');
        $footerCollection->addJs('https://cdn.jsdelivr.net/npm/nouislider@15.7.0/dist/nouislider.min.js');
        
        $area = $this->dispatcher->getParam('area');
        $a = Areas::findFirst([
            'conditions' => 'area_url = :area: AND area_status = 1',
            'bind' => ['area' => $area]
        ]);
        $this->tag->setTitle($a->area_name.'\'s Accommodation, '.$a->area_name.'\'s things to do, Accommodations & things to do in '.$a->area_name);
        $currentPage = (int) $this->dispatcher->getParam('page', 'int', 1); // Default halaman = 1
        $itemsPerPage = 9; // Maksimal item per halaman
        $offset = ($currentPage - 1) * $itemsPerPage;
        //list sub area
        $q = "SELECT a.id_area, a.iso2, a.area_parent, a.area_name, a.area_url, a.area_status, a.area_description, a.area_view,  (SELECT f.name FROM Upload_file_morph uf LEFT JOIN Upload_file f ON f.id = uf.upload_file_id WHERE uf.related_type = 'areas' AND uf.related_id = a.id_area LIMIT 0,1) as picture FROM Areas a WHERE area_parent = '".$a->id_area."' AND area_status = 1 ORDER BY a.area_name DESC LIMIT $itemsPerPage OFFSET $offset";
        $sa = $this->modelsManager->executeQuery($q);

        // hitung total produk
        $countQuery = "SELECT COUNT(*) as total 
        FROM Areas a 
        WHERE a.area_parent = :area_parent: AND area_status = 1";
       $totalProducts = $this->modelsManager->executeQuery($countQuery, ['area_parent' => $a->id_area])->getFirst()->total;
        // $sa = Areas::find([
        //     'conditions' => 'area_parent = :area_parent: AND area_status = 1',
        //     'bind' => ['area_parent' => $a->id_area]
        // ]);


        $totalPages = ceil($totalProducts / $itemsPerPage);

        $this->view->setVar('area',$a);
        $this->view->setVar('subarea',$sa);
        $this->view->setVar('currentPage', $currentPage);
        $this->view->setVar('totalProducts', $totalProducts);
        $this->view->setVar('totalPages', $totalPages);
        $this->view->pick('areas/index');
    }

    public function detailAction()
    {
            $area = $this->dispatcher->getParam('area');
            $a = Areas::findFirst([
                'conditions' => 'area_url = :area: AND area_status = 1',
                'bind' => ['area' => $area]
            ]);
            $subarea = $this->dispatcher->getParam('subarea');
            $sa = Areas::findFirst([
                'conditions' => 'area_url = :area: AND area_status = 1',
                'bind' => ['area' => $subarea]
            ]);
            
            $this->tag->setTitle($sa->area_name.'\'s Accommodation, '.$sa->area_name.'\'s things to do, Accommodations & things to do in '.$sa->area_name);

            $headerCollection = $this->assets->collection('header');
            $headerCollection->addCss('https://cdn.jsdelivr.net/npm/swiper/swiper-bundle.min.css');
            $headerCollection->addCss('https://cdn.jsdelivr.net/npm/glightbox@3.0.7/dist/css/glightbox.min.css');
            $headerCollection->addCss('css/custom.css');
            $headerCollection->addCss('css/navbar.css');



            $footerCollection = $this->assets->collection('footer');
            $footerCollection->addJs('https://cdn.jsdelivr.net/npm/swiper/swiper-bundle.min.js');
            $footerCollection->addJs('https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js');
            $footerCollection->addJs('https://cdn.jsdelivr.net/npm/glightbox@3.0.7/dist/js/glightbox.min.js');
            $footerCollection->addJs('js/areas.js');

            $currentPage = (int) $this->dispatcher->getParam('page', 'int', 1);
            $itemsPerPage = 9;
            $offset = ($currentPage - 1) * $itemsPerPage;

            $countQuery = "SELECT COUNT(DISTINCT p.id) as total 
                FROM Products p 
                LEFT JOIN Rates r ON r.product = p.id 
                LEFT JOIN Rate_options ro ON ro.id_rate = r.id AND ro.rate_option_price > 0 
                LEFT JOIN Areas_products ap ON ap.id_product = p.id 
                LEFT JOIN Areas a ON a.id_area = ap.id_area 
                WHERE p.product_status = 1
                    AND EXISTS (
                SELECT 1 FROM Rates r2
                JOIN Rate_options ro2 ON ro2.id_rate = r2.id
                JOIN Rate_availability ra2 ON ra2.id_rate_opt = ro2.id
                WHERE r2.product = p.id AND ra2.publish_price > 0
                )
                AND a.id_area = :area_id:";

            $totalProducts = $this->modelsManager->executeQuery($countQuery, [
                'area_id' => $sa->id_area
            ])->getFirst()['total'];

            $totalPages = ceil($totalProducts / $itemsPerPage);


            // Query untuk produk
            $q = "SELECT p.id, p.name, p.slug, p.description, p.page_title, p.group_product, p.provider, p.ordered,f.name AS picture, ro.id AS id_rate_options,ro.rate_option_price, ra.publish_price AS price, (SELECT SUM(pr.review_star)/COUNT(pr.id) FROM Product_reviews pr WHERE pr.product_id = p.id) AS review 
            FROM Products p 
            LEFT JOIN Rates r ON r.product = p.id 
            LEFT JOIN Rate_options ro ON ro.id_rate = r.id AND ro.rate_option_price > 0 
            LEFT JOIN Upload_file_morph uf ON uf.related_id = p.id AND uf.related_type = 'products' 
            LEFT JOIN Upload_file f ON f.id = uf.upload_file_id
            LEFT JOIN Rate_availability ra ON ra.id_rate_opt = ro.id
            LEFT JOIN Areas_products ap ON ap.id_product = p.id 
            LEFT JOIN Areas a ON a.id_area = ap.id_area 
            WHERE p.product_status = 1
            AND EXISTS (
                SELECT 1 FROM Rates r2
                JOIN Rate_options ro2 ON ro2.id_rate = r2.id
                JOIN Rate_availability ra2 ON ra2.id_rate_opt = ro2.id
                WHERE r2.product = p.id AND ra2.publish_price > 0
                )
            AND a.id_area = :area_id:
            GROUP BY p.id
            ORDER BY p.id DESC
            LIMIT $itemsPerPage OFFSET $offset"; 

            $products = $this->modelsManager->executeQuery($q, ['area_id' => $sa->id_area]);

            $arrdata = [];
            $reviewStats = []; 
            foreach ($products as $key => $val) {
                $minPriceQuery = "SELECT MIN(ra.publish_price) AS min_price
                            FROM Rates r
                            JOIN Rate_options ro ON ro.id_rate = r.id
                            JOIN Rate_availability ra ON ra.id_rate_opt = ro.id
                            WHERE r.product = :product_id: AND ra.publish_price > 0";
                $minPriceResult = $this->modelsManager->executeQuery($minPriceQuery, [
                    'product_id' => $val['id']
                ]);
                $minPublishPrice = $minPriceResult[0]['min_price'] ?? 0;

                $discounted_price = $minPublishPrice;
            
                if (!empty($val['id_rate_options'])) {
                $q3 = "SELECT h.hotdeal_type, h.hotdeal_value, promo_status 
                    FROM Hotdeals h 
                    WHERE FIND_IN_SET(:rate_option_id:, h.rates) > 0";
                $hotdeals = $this->modelsManager->executeQuery($q3, [
                    'rate_option_id' => $val['id_rate_options']
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

            $arrdata[$val->id] = [
                'rate_option_price' => $minPublishPrice,
                'discounted_price' => max($discounted_price, 0),
                'min_publish_price' => $minPublishPrice
            ];

            $qr = "SELECT rev.id, rev.parent_id, rev.product_id, rev.review_star, rev.review_comment, rev.review_name, rev.review_country, rev.created_at FROM Product_reviews rev WHERE product_id = '".$val['id']."' ORDER BY rev.created_at DESC";
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


        $reviewStats[$val->id] = [
            'total_review'   => $totalReviews,
            'average_rating' => $averageRating,
            'product_rating' => $rev->review_star,
            'is_provider'    => ($reviewer == 0) ? true : false
        ];

            }

        $wishlistProductIds = [];

		if ($this->session->has('trop_auth')) {
			$customerEmail = $this->session->get('trop_auth')['customer_email'];

			$wishlistId = Wishlist::findFirst([
				'conditions' => 'customer_email = :email:',
				'bind' => ['email' => $customerEmail],
			]);

			$wishlistItems = Wishlist_detail::find([
				'conditions' => 'id_wishlist = :id:',
				'bind' => ['id' => $wishlistId->id],
			]);

			foreach ($wishlistItems as $item) {
				$wishlistProductIds[] = $item->id_product;
			}
		}

		$this->view->setVar('wishlistProductIds', $wishlistProductIds);


            $this->view->setVar('products', $products);
            $this->view->setVar('hotdeals', $arrdata);
            $this->view->setVar('mainarea',$a);
            $this->view->setVar('area',$sa);
            $this->view->setVar('currentPage', $currentPage);
            $this->view->setVar('totalPages', $totalPages);
            $this->view->setVar('reviewStats', $reviewStats);
            $this->view->setVar('productCount', $totalProducts);

            //update view area
            $areax = Areas::findFirst([
                'conditions' => 'area_url = :area: AND area_status = 1',
                'bind' => ['area' => $subarea]
            ]);
            $areax->area_view =  $areax->area_view + 1;
            $areax->save();
            $this->view->pick('areas/detail');
            
    }


    public function ratingfilterAction(){
        $headerCollection = $this->assets->collection('header');
        $headerCollection->addCss('https://cdn.jsdelivr.net/npm/swiper/swiper-bundle.min.css');

        $footerCollection = $this->assets->collection('footer');
        $footerCollection->addJs('https://cdn.jsdelivr.net/npm/swiper/swiper-bundle.min.js');
        $this->view->disable();

        $this->response->setHeader('Content-Type', 'application/json');

        $ratings = $this->request->getPost('ratings', null, []);
        $ratings = array_map('intval', $ratings);

        $currentPage = (int) $this->dispatcher->getParam('page', 'int', 1);
        $itemsPerPage = 9;
        $offset = ($currentPage - 1) * $itemsPerPage;

        $subareaUrl = $this->dispatcher->getParam('area');
        $areaUrl = $this->dispatcher->getParam('subarea');

        $area = Areas::findFirst([
            'conditions' => 'area_url = :url: AND area_status = 1',
            'bind' => ['url' => $areaUrl]
        ]);

        $subarea = Areas::findFirst([
            'conditions' => 'area_url = :url: AND area_status = 1',
            'bind' => ['url' => $subareaUrl]
        ]);

        if (!$subarea || !$area) {
            return $this->response->redirect('404');
        }


        $productIds = [];
        // $areaIds = [$subarea->id_area];


        $areaProducts = Areas_products::find([
            'conditions' => 'id_area = :id:',
            'bind' => ['id' => $subarea->id_area]
        ]);

        foreach ($areaProducts as $ap) {
            $productIds[] = $ap->id_product;
        }


        $products = [];
        $reviewStats = [];
        $arrdata = [];

        if (!empty($productIds)) {
            $idsString = implode(',', $productIds);

            $q = "SELECT p.id, p.name, p.slug, p.description, p.page_title, p.group_product, p.provider, p.ordered,
                        f.name AS picture, ro.id AS id_rate_options, ro.rate_option_price, ra.publish_price AS price
                    FROM Products p
                    LEFT JOIN Rates r ON r.product = p.id 
                    LEFT JOIN Rate_options ro ON ro.id_rate = r.id AND ro.rate_option_price > 0 
                    LEFT JOIN Upload_file_morph uf ON uf.related_id = p.id AND uf.related_type = 'products' 
                    LEFT JOIN Upload_file f ON f.id = uf.upload_file_id
                    LEFT JOIN Rate_availability ra ON ra.id_rate_opt = ro.id
                    WHERE p.product_status = 1
                    AND p.id IN ($idsString)
                    AND EXISTS (
                        SELECT 1 FROM Rates r2
                        JOIN Rate_options ro2 ON ro2.id_rate = r2.id
                        JOIN Rate_availability ra2 ON ra2.id_rate_opt = ro2.id
                        WHERE r2.product = p.id AND ra2.publish_price > 0
                    )
                    GROUP BY p.id
                    ORDER BY p.id DESC";

            $allProducts = $this->modelsManager->executeQuery($q);

            $rawReviewQuery = $this->modelsManager->executeQuery("SELECT product_id, AVG(review_star) AS avg_rating, COUNT(*) AS total_review FROM Product_reviews WHERE product_id IN ({ids:array}) AND parent_id = 0 GROUP BY product_id", ['ids' => $productIds]);

            foreach ($rawReviewQuery as $r) {
                $reviewStats[$r->product_id] = [
                    'average_rating' => round($r->avg_rating, 1),
                    'total_review' => $r->total_review,
                    'is_provider' => false
                ];
            }

            foreach ($allProducts as $p) {
                if (!isset($reviewStats[$p->id])) {
                    $providerProducts = Products::find([
                        'conditions' => 'provider = :pid:',
                        'bind' => ['pid' => $p->provider],
                        'columns' => 'id'
                    ]);

                    $providerProductIds = array_column($providerProducts->toArray(), 'id');

                    if (!empty($providerProductIds)) {
                        $providerReviews = $this->modelsManager->executeQuery("SELECT AVG(review_star) AS avg_rating, COUNT(*) AS total_review FROM Product_reviews WHERE product_id IN ({ids:array})", ['ids' => $providerProductIds]);

                        $avg = $providerReviews[0]->avg_rating ?? 0;
                        $count = $providerReviews[0]->total_review ?? 0;

                        if ($count > 0) {
                            $reviewStats[$p->id] = [
                                'average_rating' => round($avg, 1),
                                'total_review' => $count,
                                'is_provider' => true
                            ];
                        }
                    }
                }
            }

            $filteredProducts = [];
            foreach ($allProducts as $p) {
                $rating = isset($reviewStats[$p->id]) ? round($reviewStats[$p->id]['average_rating']) : 0;

                if (empty($ratings)) {
                    $filteredProducts[] = $p;
                } elseif (
                    isset($reviewStats[$p->id]) &&
                    !$reviewStats[$p->id]['is_provider'] &&
                    in_array($rating, $ratings)
                ) {
                    $filteredProducts[] = $p;
                }
            }

            $totalProducts = count($filteredProducts);
            $totalPages = ceil($totalProducts / $itemsPerPage);
            $products = array_slice($filteredProducts, $offset, $itemsPerPage);

            $productArray = [];
            foreach ($products as $val) {
                $minPriceQuery = "SELECT MIN(ra.publish_price) AS min_price FROM Rates r JOIN Rate_options ro ON ro.id_rate = r.id JOIN Rate_availability ra ON ra.id_rate_opt = ro.id WHERE r.product = :product_id: AND ra.publish_price > 0";
                $minPriceResult = $this->modelsManager->executeQuery($minPriceQuery, ['product_id' => $val->id]);
                $minPublishPrice = $minPriceResult[0]['min_price'] ?? 0;
                $discounted_price = $minPublishPrice;

                if (!empty($val->id_rate_options)) {
                    $q3 = "SELECT h.hotdeal_type, h.hotdeal_value, promo_status FROM Hotdeals h WHERE FIND_IN_SET(:rate_option_id:, h.rates) > 0";
                    $hotdeals = $this->modelsManager->executeQuery($q3, ['rate_option_id' => (string) $val->id_rate_options]);

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

                $imagesQuery = "
                    SELECT f.name as picture 
                    FROM Upload_file_morph uf
                    JOIN Upload_file f ON f.id = uf.upload_file_id 
                    WHERE uf.related_type = 'products' 
                    AND uf.field = 'images'
                    AND uf.related_id = :product_id:
                    ORDER BY f.id
                ";

                $imageResults = $this->modelsManager->executeQuery($imagesQuery, [
                    'product_id' => $val->id
                ]);

                $productImages = [];
                foreach ($imageResults as $img) {
                    $productImages[] = $img->picture;
                }

                $arrdata[$val->id] = [
                    'rate_option_price' => $minPublishPrice,
                    'discounted_price' => max($discounted_price, 0),
                    'min_publish_price' => $minPublishPrice
                ];

                $productArray[] = [
                    'id' => $val->id,
                    'name' => $val->name,
                    'slug' => $val->slug,
                    'picture' => $val->picture,
                    'pictures' => $productImages,
                    'title' => $val->page_title,
                    'group' => $val->group_product,
                    'ordered' => $val->ordered,
                ];
            }
        } else {
            $totalProducts = 0;
            $totalPages = 0;
        }

        $wishlistProductIds = [];

		if ($this->session->has('trop_auth')) {
			$customerEmail = $this->session->get('trop_auth')['customer_email'];

			$wishlistId = Wishlist::findFirst([
				'conditions' => 'customer_email = :email:',
				'bind' => ['email' => $customerEmail],
			]);

			$wishlistItems = Wishlist_detail::find([
				'conditions' => 'id_wishlist = :id:',
				'bind' => ['id' => $wishlistId->id],
			]);

			foreach ($wishlistItems as $item) {
				$wishlistProductIds[] = $item->id_product;
			}
		}

		$this->view->setVar('wishlistProductIds', $wishlistProductIds);

        $this->response->setContent(json_encode([
            'area'          => $subarea,
            'products'      => $productArray,
            'hotdeals'      => $arrdata,
            'totalproducts' => $totalProducts,
            'currentPages'  => $currentPage,
            'images'         => $productImages,
            'totalPages'    => $totalPages,
            'reviewStats'   => $reviewStats,
            'wishlistProductIds'   => $wishlistProductIds,
        ]));

        return $this->response;
    }


}