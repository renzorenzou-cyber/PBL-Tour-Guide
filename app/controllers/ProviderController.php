<?php

class ProviderController extends ControllerBase
{

    public function indexAction()
    {
        $headerCollection = $this->assets->collection('header');
        $headerCollection->addCss('https://cdn.jsdelivr.net/npm/@fancyapps/ui@5.0/dist/fancybox/fancybox.css'); 
        $headerCollection->addCss('https://cdn.jsdelivr.net/npm/@fancyapps/ui/dist/fancybox.css');
        $headerCollection->addCss('https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css');
        $headerCollection->addCss('https://unpkg.com/leaflet/dist/leaflet.css');
        $headerCollection->addCss('https://unpkg.com/leaflet-routing-machine@latest/dist/leaflet-routing-machine.css');
        $headerCollection->addCss('css/provider.css');
        $headerCollection->addCss('css/navbar.css');

        
        $footerCollection = $this->assets->collection('footer');
        $footerCollection->addJs('https://cdn.jsdelivr.net/npm/moment@2.29.1/moment.min.js');
        $footerCollection->addJs('https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js');
        $footerCollection->addJs('https://unpkg.com/sweetalert/dist/sweetalert.min.js');
        $footerCollection->addJs('https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js');
        $footerCollection->addJs('https://cdn.jsdelivr.net/npm/@fancyapps/ui@5.0/dist/fancybox/fancybox.umd.js');
        $footerCollection->addJs('https://cdn.jsdelivr.net/npm/@fancyapps/ui/dist/fancybox.umd.js');
        $footerCollection->addJs('https://unpkg.com/leaflet/dist/leaflet.js');
        $footerCollection->addJs('https://unpkg.com/leaflet-routing-machine@latest/dist/leaflet-routing-machine.min.js');
        $footerCollection->addJs('js/provider.js');

        $provider = $this->dispatcher->getParam('provider_name');
        $currentPage = (int) $this->dispatcher->getParam('page', 'int', 1);
        $tab = $this->dispatcher->getParam('tab');
        $itemsPerPage = 4;
        $offset = ($currentPage - 1) * $itemsPerPage;

        $q = "SELECT pr.id, pr.name, pr.slug, pr.description, pr.address, pr.latitude, pr.longitude
            FROM Providers pr 
            WHERE pr.slug = :prov_url:";

        $result = $this->modelsManager->executeQuery($q, ['prov_url' => $provider]);

        $pro = Providers::findFirst([
            'conditions' => 'slug = :provider:',
            'bind' => ['provider' => $provider]
        ]);

        $title = $pro->name;

        $prov = $result->getFirst(); 
        if (!$prov) {
            // provider tidak ditemukan
            $productsIds = [];
        } else {
            // product
            $providerId = $prov->id;

            $products = Products::find([
                'conditions' => 'provider = :provider:',
                'bind' => ['provider' => $providerId]
            ]);

            $productsIds = [];
            foreach ($products as $pr) {
                $productsIds[] = $pr->id;
            }

            $providerAverageRating = 0;
            $providerTotalReviews = 0;
            $order = 0;
            $cheapestProduct = null;

            if (!empty($productsIds)) {
                // provider rating
                 $q = "SELECT review_star FROM Product_reviews 
                    WHERE product_id IN ({ids:array}) AND parent_id = 0";

                $reviews = $this->modelsManager->executeQuery($q, [
                    'ids' => $productsIds
                ]);

                $totalStars = 0;
                $providerTotalReviews = count($reviews);

                foreach ($reviews as $r) {
                    $totalStars += $r->review_star;
                }

                if ($providerTotalReviews > 0) {
                    $providerAverageRating = round($totalStars / $providerTotalReviews, 1);
                }

                // ordered
                $q2 = "SELECT ordered FROM Products 
                    WHERE id IN ({ids:array})";

                $ordered = $this->modelsManager->executeQuery($q2, [
                    'ids' => $productsIds
                ]);

                foreach ($ordered as $or) {
                    $ordereds += $or->ordered;
                }

                // products
                $idsString = implode(',', $productsIds);

                $q3 = "SELECT p.id, p.name, p.slug, p.description, p.page_title, p.group_product, p.provider, p.ordered,
                    f.name AS picture, ro.id AS id_rate_options, ro.rate_option_price, ra.publish_price AS price,
                    (SELECT SUM(pr.review_star)/COUNT(pr.id) FROM Product_reviews pr WHERE pr.product_id = p.id) AS review
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
                    ORDER BY p.id DESC
                    LIMIT $itemsPerPage OFFSET $offset";

                $productsList = $this->modelsManager->executeQuery($q3);

                $countQuery = "
                    SELECT COUNT(DISTINCT p.id) AS total
                    FROM Products p
                    LEFT JOIN Rates r ON r.product = p.id 
                    LEFT JOIN Rate_options ro ON ro.id_rate = r.id 
                    LEFT JOIN Rate_availability ra ON ra.id_rate_opt = ro.id AND ra.publish_price > 0
                    WHERE p.product_status = 1
                    AND p.id IN ($idsString)
                    AND ra.publish_price > 0
                ";

                $countResult = $this->modelsManager->executeQuery($countQuery);

                $totalProducts = $countResult[0]->total ?? 0;
                $totalPages = ceil($totalProducts / $itemsPerPage);

                $arrdata = [];
                $reviewStats = [];
                foreach ($productsList as $key => $val) {
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
                        $q3 = "SELECT h.hotdeal_type, h.hotdeal_value, promo_status 
                            FROM Hotdeals h 
                            WHERE FIND_IN_SET(:rate_option_id:, h.rates) > 0";
                        $hotdeals = $this->modelsManager->executeQuery($q3, [
                            'rate_option_id' => $val->id_rate_options
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

                    $productAverageRating = 0;
                    $productTotalReviews = $reviewer;

                    if ($productTotalReviews > 0) {
                        foreach ($rev as $r) {
                            $totalStarsProduct += $r->review_star;
                        }
                        $productAverageRating = round($totalStarsProduct / $productTotalReviews, 1);
                    } else {
                        // fallback provider rating
                        $productAverageRating = $providerAverageRating;
                        $productTotalReviews = $providerTotalReviews;
                    }

                    $reviewStats[$val->id] = [
                        'total_review'   => $productTotalReviews,
                        'average_rating' => $productAverageRating,
                        'product_rating' => $rev->review_star,
                        'is_provider'    => ($reviewer == 0) ? true : false
                    ];

                    // lowest price
                    $cheapestQuery = "
                        SELECT p.id, p.name, p.slug, p.description, p.page_title, p.group_product, p.provider, 
                            ra.publish_price, ro.id AS rate_option_id
                        FROM Products p
                        JOIN Rates r ON r.product = p.id
                        JOIN Rate_options ro ON ro.id_rate = r.id
                        JOIN Rate_availability ra ON ra.id_rate_opt = ro.id
                        WHERE p.id IN ($idsString) AND ra.publish_price > 0
                        ORDER BY ra.publish_price ASC
                        LIMIT 1
                    ";

                    $cheapestResult = $this->modelsManager->executeQuery($cheapestQuery);
                    if (count($cheapestResult)) {
                        $cheapestProduct = $cheapestResult[0];
                    }

                    // customer review
                    $Reviewpage = $this->dispatcher->getParam('reviewpage', 'int', 1);

                    $ReviewperPage = 4;
                    $Reviewoffset = ($Reviewpage - 1) * $ReviewperPage;

                        $qrc = sprintf(
                            "SELECT * FROM Product_reviews 
                            WHERE product_id IN ($idsString) AND parent_id = 0
                            ORDER BY created_at DESC
                            LIMIT %d OFFSET %d",
                            $ReviewperPage,
                            $Reviewoffset
                        );
                    
                        $revc = $this->modelsManager->executeQuery($qrc);

                        $reviewerc = Product_reviews::count([
                            'conditions' => 'product_id IN ({ids:array}) AND parent_id = 0',
                            'bind' => [
                                'ids' => $productsIds,
                            ],
                        ]);

                    
                    $reviews = [];
                    foreach ($revc as $r) {
                        $rp = Order_details::findFirst([
                            'conditions' => 'id = :id:',
                            'bind' => ['id' => $r->order_detail_id],
                        ]);

                        $rate_name = $rp->rate_name ?? '';
                        $rate_opt_name = $rp->rate_opt_name ?? '';
                        $product_name = $rp->product_name ?? '';

                        $reviewImages = $this->modelsManager->executeQuery("
                            SELECT f.* FROM upload_file_morph uf
                            LEFT JOIN upload_file f ON uf.upload_file_id = f.id
                            WHERE uf.related_id = :review_id: AND uf.related_type = 'reviews' AND uf.field = 'images'
                        ", ['review_id' => $r->id]);

                        $reviewVideos = $this->modelsManager->executeQuery("
                            SELECT f.* FROM upload_file_morph uf
                            LEFT JOIN upload_file f ON uf.upload_file_id = f.id
                            WHERE uf.related_id = :review_id: AND uf.related_type = 'reviews' AND uf.field = 'videos'
                        ", ['review_id' => $r->id]);

                        $replies = Product_reviews::find([
                            'conditions' => 'parent_id = :parent_id:',
                            'bind' => ['parent_id' => $r->id],
                            'order' => 'created_at ASC'
                        ]);

                        $formattedReplies = [];
                        foreach ($replies as $reply) {
                            $replyImages = $this->modelsManager->executeQuery("
                                SELECT f.* FROM upload_file_morph uf
                                LEFT JOIN upload_file f ON uf.upload_file_id = f.id
                                WHERE uf.related_id = :review_id: AND uf.related_type = 'reviews' AND uf.field = 'images'
                            ", ['review_id' => $reply->id]);

                            $replyVideos = $this->modelsManager->executeQuery("
                                SELECT f.* FROM upload_file_morph uf
                                LEFT JOIN upload_file f ON uf.upload_file_id = f.id
                                WHERE uf.related_id = :review_id: AND uf.related_type = 'reviews' AND uf.field = 'videos'
                            ", ['review_id' => $reply->id]);

                            $formattedReplies[] = [
                                'review_id'      => $reply->id,
                                'parent_id'      => $reply->parent_id,
                                'review_name'    => $reply->review_name,
                                'created_at'     => $reply->created_at,
                                'formatted_date' => date('d F Y', strtotime($reply->created_at)),
                                'review_star'    => $reply->review_star,
                                'review_comment' => $reply->review_comment,
                                'review_country' => $reply->review_country,
                                'rate_name'      => '',
                                'rate_opt_name'  => '',
                                'images'         => $replyImages,
                                'videos'         => $replyVideos,
                            ];
                        }

                        $reviews[] = [
                            'review_id'      => $r->id,
                            'parent_id'      => $r->parent_id,
                            'review_name'    => $r->review_name,
                            'created_at'     => $r->created_at,
                            'formatted_date' => date('d F Y', strtotime($r->created_at)),
                            'review_star'    => $r->review_star,
                            'review_comment' => $r->review_comment,
                            'review_country' => $r->review_country,
                            'rate_name'      => $rate_name,
                            'rate_opt_name'  => $rate_opt_name,
                            'product_name'   => $product_name,
                            'images'         => $reviewImages,
                            'videos'         => $reviewVideos,
                            'replies'        => $formattedReplies,
                        ];
                    }

                    $totalPagesReview = ceil($reviewerc / $ReviewperPage);

                    $baseUrl =   'provider/' . $provider;
                    $isReviewTab = strpos($this->request->getURI(), '/review/') !== false;

                }
            }

        }

        $uploadedVideos = [];
        if ($prov) {
            $uploadedVideos = $this->modelsManager->createBuilder()
                ->from(['upload_file' => 'Upload_file'])
                ->columns('upload_file.*')
                ->join('Upload_file_morph', "ufm.upload_file_id = upload_file.id AND ufm.related_type = 'providers' AND ufm.related_id = :pid: AND ufm.field = 'videos'", 'ufm')
                ->orderBy('upload_file.id DESC')
                ->getQuery()
                ->execute(['pid' => $prov->id]);
        }

        $uploadedPhotos = [];
        if ($prov) {
            $uploadedPhotos = $this->modelsManager->createBuilder()
            ->from(['upload_file' => 'Upload_file'])
            ->columns('upload_file.*')
            ->join('Upload_file_morph', "ufm.upload_file_id = upload_file.id AND ufm.related_type = 'providers' AND ufm.related_id = :pid: AND ufm.field = 'photos'", 'ufm')
            ->orderBy('upload_file.id DESC')
            ->getQuery()
            ->execute(['pid' => $prov->id]);
        }

        $randomProductImages = [];

        if (count($productsList) > 0) {
            $productIds = [];
            foreach ($productsList as $p) {
                $productIds[] = $p->id;
            }

            $randomProductImages = $this->modelsManager->createBuilder()
                ->from(['upload_file' => 'Upload_file'])
                ->columns('upload_file.*')
                ->join('Upload_file_morph', "ufm.upload_file_id = upload_file.id AND ufm.related_type = 'products' AND ufm.field = 'images'", 'ufm')
                ->inWhere('ufm.related_id', $productIds)
                ->orderBy('RAND()')
                ->limit(5)
                ->getQuery()
                ->execute();
        }

        // print_r($totalPagesReview);die();

        $this->view->setVar('provider', $prov);
        $this->view->setVar('average_rating', $providerAverageRating);
        $this->view->setVar('total_review', $providerTotalReviews);
        $this->view->setVar('products', $productsList);
        $this->view->setVar('hotdeals', $arrdata);
        $this->view->setVar('reviewStats', $reviewStats);
        $this->view->setVar('ordered', $ordereds);
        $this->view->setVar('cheapest', $cheapestProduct);
        $this->view->setVar('totalProducts', $totalProducts);
        $this->view->setVar('currentPage', $currentPage);
        $this->view->setVar('currentPageReview', $Reviewpage);
        $this->view->setVar('totalPages', $totalPages);
        $this->view->setVar('totalPagesReview', $totalPagesReview);
        $this->view->setVar('tab', $tab);
        $this->view->setVar('current_path', $this->request->getURI());
        $this->view->setVar('picUrl', $this->config->vars->picUrl); 
        $this->view->setVar('reviews', $reviews);
        $this->view->setVar('review', $reviews);
        $this->view->setVar('perPage', $perPage);
        $this->view->setVar('ReviewperPage', $ReviewperPage);
        $this->view->setVar('uploadedPhotos', $uploadedPhotos);
        $this->view->setVar('randomProductImages', $randomProductImages);
        $this->view->setVar('uploadedVideos', $uploadedVideos);

        $this->tag->setTitle($title);
        // $this->view->pick('provider/index');

    }



}

