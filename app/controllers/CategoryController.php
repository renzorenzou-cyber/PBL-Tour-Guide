<?php

class CategoryController extends ControllerBase
{
    public function indexAction()
    {

    }

    public function detailAction()
{
    $headerCollection = $this->assets->collection('header');
    $headerCollection->addCss('https://cdn.jsdelivr.net/npm/swiper/swiper-bundle.min.css');
    $headerCollection->addCss('https://cdn.jsdelivr.net/npm/@fancyapps/ui@5.0/dist/fancybox/fancybox.css');
    $headerCollection->addCss('css/navbar.css');


    $footerCollection = $this->assets->collection('footer');
    $footerCollection->addJs('https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js');
    $footerCollection->addJs('https://cdn.jsdelivr.net/npm/swiper/swiper-bundle.min.js');
    $footerCollection->addJs('https://cdn.jsdelivr.net/npm/@fancyapps/ui@5.0/dist/fancybox/fancybox.umd.js'); 
    $footerCollection->addJs('js/category.js');

    // Ambil parameter halaman dari URL
    $currentPage = (int) $this->dispatcher->getParam('page', 'int', 1);
    $itemsPerPage = 9;
    $offset = ($currentPage - 1) * $itemsPerPage;

    // Ambil parameter kategori dari URL
    $categoryUrl = $this->dispatcher->getParam('category_url');

    $q = "SELECT id, group_product, group_product_url, group_description, group_pagetitle  
          FROM Group_products 
          WHERE group_product_url = :category_url: 
          AND group_product_status = 1";
    $cat = $this->modelsManager->executeQuery($q, ['category_url' => $categoryUrl]);

    if (count($cat) === 0) {
        $this->response->redirect('404');
        return;
    }

    

    if($this->session->has('areas') != 1){
			$this->session->set('areas', [
				'default' => 'bali',
				'selected' => 'bali'
			]);
		}

    $areaSlug = $this->session->get('areas')['selected'];
    $productIds = [];

    if ($areaSlug) {
        $area = Areas::findFirst([
            'conditions' => 'area_url = :slug:',
            'bind' => ['slug' => $areaSlug]
        ]);

        if ($area) {
            $parentId = $area->id_area;

            // Ambil sub-area dari parent area
            $subAreas = Areas::find([
                'conditions' => 'area_parent = :parent:',
                'bind' => ['parent' => $parentId]
            ]);

            $areaIds = [$parentId];
            foreach ($subAreas as $sub) {
                $areaIds[] = $sub->id_area;
            }

            // Cari produk yang terhubung dengan area-area tersebut
            $areaProducts = Areas_products::find([
                'conditions' => 'id_area IN ({ids:array})',
                'bind' => ['ids' => $areaIds]
            ]);

            foreach ($areaProducts as $ap) {
                $productIds[] = $ap->id_product;
            }

            $filteredProductIds = [];
            $filteredProdcutPrice = [];

            if (!empty($productIds)) {
                // Ambil semua id produk yang termasuk group_product tertentu
                $groupProductProducts = Products::find([
                    'conditions' => 'id IN ({ids:array}) AND group_product = :group_product: AND product_status = 1',
                    'bind' => [
                        'ids' => $productIds,
                        'group_product' => $cat[0]['group_product']
                    ],
                    'columns' => 'id'
                ]);

                foreach ($groupProductProducts as $pp) {
                    $filteredProductIds[] = $pp->id;
                }
            }

            // $groupProductProducts = Products::find([
                //     'conditions' => 'id IN ({ids:array}) AND group_product = :group_product: AND product_status = 1',
                //     'bind' => [
                //         'ids' => $productIds,
                //         'group_product' => $cat[0]['group_product']
                //     ],
                //     'columns' => 'id'
                // ]);

                // foreach ($groupProductProducts as $pp) {
                //     $filteredProductIds[] = $pp->id;
                // }

                $groupProductProducts = $this->modelsManager->createBuilder()
						->from('Products')
						->inWhere('id', $productIds)
						->andWhere('product_status = 1')
						->andWhere("EXISTS (
							SELECT 1 FROM Rates r
							JOIN Rate_options ro ON ro.id_rate = r.id
							JOIN Rate_availability ra ON ra.id_rate_opt = ro.id
							WHERE r.product = Products.id AND ra.publish_price > 0
						)");

					$activeProducts = $groupProductProducts->getQuery()->execute();

					foreach ($activeProducts as $pp) {
                        $filteredProdcutPrice[] = $pp->id;
                    }
        }
    }


        $validProductIds = array_intersect($filteredProductIds, $filteredProdcutPrice);

        if (!empty($validProductIds)) {
            $idsString = implode(',', $validProductIds);

        $q = "SELECT p.id, p.name, p.slug, p.description, p.page_title, p.group_product, p.provider, p.ordered,
            f.name AS picture, ro.id AS id_rate_options, ro.rate_option_price, ra.publish_price AS price,
            (SELECT SUM(pr.review_star)/COUNT(pr.id) FROM Product_reviews pr WHERE pr.product_id = p.id) AS review,
            (SELECT COUNT(ps.id) FROM Product_reviews ps WHERE ps.product_id = p.id) AS reviewcount
            FROM Products p
            LEFT JOIN Rates r ON r.product = p.id 
            LEFT JOIN Rate_options ro ON ro.id_rate = r.id AND ro.rate_option_price > 0 
            LEFT JOIN Upload_file_morph uf ON uf.related_id = p.id AND uf.related_type = 'products' 
            LEFT JOIN Upload_file f ON f.id = uf.upload_file_id
            LEFT JOIN Rate_availability ra ON ra.id_rate_opt = ro.id
            WHERE p.product_status = 1  
            AND p.group_product = :group_product:
            AND p.id IN ($idsString)
            AND EXISTS (
            SELECT 1 FROM Rates r2
            JOIN Rate_options ro2 ON ro2.id_rate = r2.id
            JOIN Rate_availability ra2 ON ra2.id_rate_opt = ro2.id
            WHERE r2.product = p.id AND ra2.publish_price > 0
            )
            GROUP BY p.id
            ORDER BY p.id DESC
            LIMIT $itemsPerPage OFFSET $offset";

        $products = $this->modelsManager->executeQuery($q, ['group_product' => $cat[0]['group_product']]);

        $countQuery = "
            SELECT COUNT(DISTINCT p.id) AS total
            FROM Products p
            LEFT JOIN Rates r ON r.product = p.id 
            LEFT JOIN Rate_options ro ON ro.id_rate = r.id 
            LEFT JOIN Rate_availability ra ON ra.id_rate_opt = ro.id AND ra.publish_price > 0
            WHERE p.product_status = 1  
            AND p.group_product = :group_product:
            AND p.id IN ($idsString)
            AND ra.publish_price > 0
        ";

        $countResult = $this->modelsManager->executeQuery($countQuery, [
            'group_product' => $cat[0]['group_product']
        ]);

        $totalProducts = $countResult[0]->total ?? 0;
        $totalPages = ceil($totalProducts / $itemsPerPage);
    } else {
        $products = []; 
    }

    $arrdata = [];
    $reviewStats = [];
    foreach ($products as $key => $val) {
        // Ambil harga publish_price terendah untuk masing-masing produk
        $minPriceQuery = "SELECT MIN(ra.publish_price) AS min_price
                          FROM Rates r
                          JOIN Rate_options ro ON ro.id_rate = r.id
                          JOIN Rate_availability ra ON ra.id_rate_opt = ro.id
                          WHERE r.product = :product_id: AND ra.publish_price > 0";
        $minPriceResult = $this->modelsManager->executeQuery($minPriceQuery, [
            'product_id' => $val->id
        ]);
        $minPublishPrice = $minPriceResult[0]['min_price'] ?? 0;

        $discounted_price = $minPublishPrice;

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

    if($this->session->get('areas')['display'] == ''){ $default_areas = $this->session->get('areas')['default']; }else{ $default_areas = $this->session->get('areas')['display'];}
	$this->tag->setTitle(str_replace("{area}",$default_areas,$cat[0]['group_pagetitle']));
    $this->view->setVar('metadesc',str_replace("{area}",$default_areas,$cat[0]['group_description']));
    
    //schemas
    $schema = [
         "@context" => "https://schema.org",
         "@type" => "ItemList",  // ✅ Use ItemList for a list of products
         "name" => str_replace("{area}", ucwords($this->session->get('areas')['selected']), $cat[0]['group_pagetitle']),  // Customize as needed
         "description" => str_replace("{area}", ucwords($this->session->get('areas')['selected']), $cat[0]['group_description']),
         "itemListElement" => []  // ✅ This is valid here
    ];

    foreach ($products as $index => $product) {
         $productSchema = [
             "@type" => "Product",
             "@id" => "https://www.tropialis.com/{$product['id']}/{$product['slug']}/",
             "name" => $product['name'],
             "description" => strip_tags($product['description']) ?? "",
             "image" => $product['picture'] ?? [],  // Assuming $imageUrls is defined
             "aggregateRating" => [
                 "@type" => "AggregateRating",
                 "ratingValue" => $product['average_rating'] ?? 5,
                 "reviewCount" => (count($review) == 0 ? "1" : count($review))
             ],
             // Add reviews as an array (not itemListElement)
             "review" => $reviewObjects ?? [],  // From your fixed review code
             // Add videos as an array
             "video" => $videoObjects ?? []  // From your fixed video code
         ];
         // Add this product to the ItemList
         $schema["itemListElement"][] = [
             "@type" => "ListItem",
             "position" => $index + 1,
             "item" => $productSchema
         ];
     }

     $this->view->schemaJson = json_encode($schema, JSON_UNSCAPED_SLASHES | JSON_PRETTY_PRINT);

    // Prepare structured data (JSON-LD)
    // //create a looping item
    // $this->view->schemaJson = json_encode([
    //     "@context" => "https://schema.org",
    //     "@type" => "Product",
    //     "name" => $cat[0]['group_product'],
    //     "description" => str_replace("{area}",$default_areas,$cat[0]['group_description']),
    //     "url"=> "https://www.tropialis.com/category/".$cat[0]['group_product_url']."/",
    //     "numberOfItems"=> count($products),
    //     "itemListElement"=> $itemList
    // ], JSON_UNSCAPED_SLASHES | JSON_PRETTY_PRINT);
    // $this->view->setVar('schemas',json_encode($schema, JSON_UNESCAPED_SLASHES | JSON_PRETTY_PRINT));


    // $itemList = [];
    // $position = 1;
    // foreach($products as $product){
    //     $itemList[] = [
    //         "@type"    => "ListItem",
    //         "position" => $position++,
    //         "url"      => "https://www.tropialis.com/".$product->id."/".$product->slug."/",
    //         "name"     => $product->name,
    //         "image"    => "https://files.tropialis.com/products/".$product->id."/".$product->picture
    //         ,
    //         "aggregateRating"=> [
    //             "@type"=> "AggregateRating",
    //             "ratingValue"=> $product->review,
    //             "reviewCount"=> $product->reviewcount
    //         ]
    //     ];
    // }
    // // Prepare structured data (JSON-LD)
    // //create a looping item
    // $this->view->schemaJson = json_encode([
    //     "@context" => "https://schema.org",
    //     "@type" => "Product",
    //     "name" => $cat[0]['group_product'],
    //     "description" => str_replace("{area}",$default_areas,$cat[0]['group_description']),
    //     "url"=> "https://www.tropialis.com/category/".$cat[0]['group_product_url']."/",
    //     "numberOfItems"=> count($products),
    //     "itemListElement"=> $itemList
    // ], JSON_UNSCAPED_SLASHES | JSON_PRETTY_PRINT);
    // $this->view->setVar('schemas',json_encode($schema, JSON_UNESCAPED_SLASHES | JSON_PRETTY_PRINT));

    $this->view->setVar('wishlistProductIds', $wishlistProductIds);
    $this->view->setVar('category', $cat[0]);
    $this->view->setVar('products', $products);
    $this->view->setVar('hotdeals', $arrdata);
    $this->view->setVar('totalProducts', $totalProducts);
    $this->view->setVar('currentPage', $currentPage);
    $this->view->setVar('totalPages', $totalPages);
    $this->view->setVar('reviewStats', $reviewStats);
    $this->view->setVar('url', $categoryUrl);
    $this->view->pick('category/index');
}

    public function ratingfilterAction()
{
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

    $categoryUrl = $this->dispatcher->getParam('category_url');

    $cat = $this->modelsManager->executeQuery(
        "SELECT id, group_product, group_product_url, group_description 
         FROM Group_products 
         WHERE group_product_url = :category_url: 
         AND group_product_status = 1",
        ['category_url' => $categoryUrl]
    );

    if (count($cat) === 0) {
        return $this->response->redirect('404');
    }

    $groupProduct = $cat[0]['group_product'];

    // Get area session
    if (!$this->session->has('areas')) {
        $this->session->set('areas', ['default' => 'bali', 'selected' => 'bali']);
    }

    $areaSlug = $this->session->get('areas')['selected'];
    $productIds = [];

    // Get area and subarea IDs
    $area = Areas::findFirst([
        'conditions' => 'area_url = :slug:',
        'bind' => ['slug' => $areaSlug]
    ]);

    if ($area) {
        $areaIds = [$area->id_area];

        $subAreas = Areas::find([
            'conditions' => 'area_parent = :parent:',
            'bind' => ['parent' => $area->id_area]
        ]);

        foreach ($subAreas as $sub) {
            $areaIds[] = $sub->id_area;
        }

        // Get all product IDs from those areas
        $areaProducts = Areas_products::find([
            'conditions' => 'id_area IN ({ids:array})',
            'bind' => ['ids' => $areaIds]
        ]);

        foreach ($areaProducts as $ap) {
            $productIds[] = $ap->id_product;
        }
    }

    $filteredProductIds = [];

    if (!empty($productIds)) {
        $groupProductProducts = Products::find([
            'conditions' => 'id IN ({ids:array}) AND group_product = :group_product:',
            'bind' => [
                'ids' => $productIds,
                'group_product' => $groupProduct
            ],
            'columns' => 'id'
        ]);

        foreach ($groupProductProducts as $pp) {
            $filteredProductIds[] = $pp->id;
        }
    }

    $products = [];
    $reviewStats = [];
    $arrdata = [];

    if (!empty($filteredProductIds)) {
        $idsString = implode(',', $filteredProductIds);

        // Ambil semua produk
        $q = "SELECT p.id, p.name, p.slug, p.description, p.page_title, p.group_product, p.provider, p.ordered,
                f.name AS picture, ro.id AS id_rate_options, ro.rate_option_price, ra.publish_price AS price
            FROM Products p
            LEFT JOIN Rates r ON r.product = p.id 
            LEFT JOIN Rate_options ro ON ro.id_rate = r.id AND ro.rate_option_price > 0 
            LEFT JOIN Upload_file_morph uf ON uf.related_id = p.id AND uf.related_type = 'products' 
            LEFT JOIN Upload_file f ON f.id = uf.upload_file_id
            LEFT JOIN Rate_availability ra ON ra.id_rate_opt = ro.id
            WHERE p.product_status = 1
            AND p.group_product = :group_product:
            AND p.id IN ($idsString)
            AND EXISTS (
            SELECT 1 FROM Rates r2
            JOIN Rate_options ro2 ON ro2.id_rate = r2.id
            JOIN Rate_availability ra2 ON ra2.id_rate_opt = ro2.id
            WHERE r2.product = p.id AND ra2.publish_price > 0
            )
            GROUP BY p.id
            ORDER BY p.id DESC";

        $allProducts = $this->modelsManager->executeQuery($q, ['group_product' => $groupProduct]);

        // Ambil review 
        $rawReviewQuery = $this->modelsManager->executeQuery("
            SELECT product_id, AVG(review_star) AS avg_rating, COUNT(*) AS total_review
            FROM Product_reviews 
            WHERE product_id IN ({ids:array}) AND parent_id = 0
            GROUP BY product_id", ['ids' => $filteredProductIds]);

        foreach ($rawReviewQuery as $r) {
            $reviewStats[$r->product_id] = [
                'average_rating' => round($r->avg_rating, 1),
                'total_review' => $r->total_review,
                'is_provider' => false
            ];
        }

        // Tambahin fallback ke provider rating
        foreach ($allProducts as $p) {
            if (!isset($reviewStats[$p->id])) {
                // Ambil semua produk dengan provider yang sama
                $providerProducts = Products::find([
                    'conditions' => 'provider = :pid:',
                    'bind' => ['pid' => $p->provider],
                    'columns' => 'id'
                ]);

                $providerProductIds = [];
                foreach ($providerProducts as $prod) {
                    $providerProductIds[] = $prod->id;
                }

                if (!empty($providerProductIds)) {
                    $providerReviews = $this->modelsManager->executeQuery("
                        SELECT AVG(review_star) AS avg_rating, COUNT(*) AS total_review
                        FROM Product_reviews
                        WHERE product_id IN ({ids:array})", ['ids' => $providerProductIds]);

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


        // Filter rating 
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
        // Hotdeals & harga
        foreach ($products as $val) {
            // Ambil minimum price
            $minPriceQuery = "SELECT MIN(ra.publish_price) AS min_price
                              FROM Rates r
                              JOIN Rate_options ro ON ro.id_rate = r.id
                              JOIN Rate_availability ra ON ra.id_rate_opt = ro.id
                              WHERE r.product = :product_id: AND ra.publish_price > 0";

            $minPriceResult = $this->modelsManager->executeQuery($minPriceQuery, [
                'product_id' => $val->id
            ]);

            $minPublishPrice = $minPriceResult[0]['min_price'] ?? 0;
            $discounted_price = $minPublishPrice;

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
    

    $this->response->setContent(json_encode([
        'category'       => $cat[0],
        'products' => $productArray,
        'hotdeals'       => $arrdata,
        'totalproducts'  => $totalProducts,
        'currentPages'   => $currentPage,
        'totalPages'     => $totalPages,
        'images'         => $productImages,
        'reviewStats'    => $reviewStats,
        'wishlistProductIds'    => $wishlistProductIds,
    ]));

    return $this->response;
}


}
