<?php

class ProductController extends ControllerBase
{

    public function indexAction()
    {

    }

    public function detailAction(){
        $headerCollection = $this->assets->collection('header');
        $headerCollection->addCss('https://cdn.jsdelivr.net/npm/@fancyapps/ui@5.0/dist/fancybox/fancybox.css'); 
        $headerCollection->addCss('https://cdn.jsdelivr.net/npm/@fancyapps/ui/dist/fancybox.css');
        $headerCollection->addCss('https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css');
        $headerCollection->addCss('https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css');
        $headerCollection->addCss('https://unpkg.com/leaflet/dist/leaflet.css');
        $headerCollection->addCss('https://unpkg.com/leaflet-routing-machine@latest/dist/leaflet-routing-machine.css');
        $headerCollection->addCss('css/detail.css');
        $headerCollection->addCss('css/navbar.css');

        
        $footerCollection = $this->assets->collection('footer');
        $footerCollection->addJs('https://cdn.jsdelivr.net/npm/moment@2.29.1/moment.min.js');
        $footerCollection->addJs('https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js');
        $footerCollection->addJs('https://unpkg.com/sweetalert/dist/sweetalert.min.js');
        $footerCollection->addJs('https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js');
        $footerCollection->addJs('https://cdn.jsdelivr.net/npm/@fancyapps/ui@5.0/dist/fancybox/fancybox.umd.js');
        $footerCollection->addJs('https://cdn.jsdelivr.net/npm/bootstrap@5.3.4/dist/js/bootstrap.bundle.min.js');
        $footerCollection->addJs('https://cdn.jsdelivr.net/npm/flatpickr');
        $footerCollection->addJs('https://cdn.jsdelivr.net/npm/@fancyapps/ui/dist/fancybox.umd.js');
        $footerCollection->addJs('https://unpkg.com/leaflet/dist/leaflet.js');
        $footerCollection->addJs('https://unpkg.com/leaflet-routing-machine@latest/dist/leaflet-routing-machine.min.js');
        $footerCollection->addJs('js/detail.js');
        
        
        $q = "SELECT p.id, p.sku, p.name, p.slug, p.description, p.page_title, p.metadata, p.provider, pr.latitude, pr.longitude, pr.name AS provider_name, pr.slug AS provider_slug,
        (SELECT opt.rate_option_price FROM Rate_options opt LEFT JOIN Rates r ON opt.id_rate = r.id WHERE r.product = p.id LIMIT 1), 
        (SELECT MIN(ra.publish_price) FROM Rate_availability ra LEFT JOIN Products p ON p.id = '".$this->dispatcher->getParam('id')."' LEFT JOIN Rates r ON r.product = p.id LEFT JOIN Rate_options opt ON opt.id_rate = r.id WHERE ra.id_rate_opt = opt.id LIMIT 1) AS price,(SELECT ra.module_id FROM Rate_availability ra LEFT JOIN Products p ON p.id = '".$this->dispatcher->getParam('id')."' LEFT JOIN Rates r ON r.product = p.id LEFT JOIN Rate_options opt ON opt.id_rate = r.id WHERE ra.id_rate_opt = opt.id LIMIT 1) AS modules,(SELECT opt.id FROM Rate_options opt LEFT JOIN Rates r ON opt.id_rate = r.id WHERE r.product = p.id LIMIT 1) AS id_rate_options, 
        p.group_product, f.name AS picture, 
        (SELECT SUM(r.review_star) / COUNT(r.id) FROM Product_reviews r WHERE r.product_id = p.id) AS review,
        (SELECT COUNT(r.id) FROM Product_reviews r WHERE r.product_id = p.id) AS reviewCount, 
        p.module, p.metadata, p.itinerary, p.inclusion_exclusion, p.policy, gp.group_product_url  
        FROM Products p 
        LEFT JOIN Group_products gp ON gp.group_product = p.group_product 
        LEFT JOIN Upload_file_morph uf ON uf.related_id = p.id 
        LEFT JOIN Upload_file f ON f.id = uf.upload_file_id  
        LEFT JOIN Providers pr ON pr.id = p.provider
        WHERE uf.related_type = 'products' 
        AND (p.published_by != 0 OR p.published_by != '')
        AND p.id = '".$this->dispatcher->getParam('id')."'";
        
        $product = $this->modelsManager->executeQuery($q);

        // Query total review & average rating tanpa filter
        $allReviews = Product_reviews::find([
            'conditions' => 'product_id = :id: AND parent_id = 0',
            'bind' => [
                'id' => $this->dispatcher->getParam('id')
            ]
        ]);

        $totalReviews = count($allReviews);
        $totalStars = 0;

        if ($totalReviews > 0) {
            foreach ($allReviews as $review) {
                $totalStars += $review->review_star;
            }
            $averageRating = round($totalStars / $totalReviews, 1); // 1 digit desimal
        } else {
            $averageRating = 0;
        }
        
        
        $imagesQuery = "SELECT f.name, f.created_at FROM Upload_file_morph uf 
                        LEFT JOIN Upload_file f ON uf.upload_file_id = f.id 
                        WHERE uf.related_id = '".$this->dispatcher->getParam('id')."' 
                        AND uf.related_type = 'products' AND uf.field = 'images'";  
        $images = $this->modelsManager->executeQuery($imagesQuery);

        $vidQuery = "SELECT f.name, f.created_at FROM Upload_file_morph uf 
        LEFT JOIN Upload_file f ON uf.upload_file_id = f.id 
        WHERE uf.related_id = '".$this->dispatcher->getParam('id')."' 
        AND uf.related_type = 'products' AND uf.field = 'videos'";  
        $video = $this->modelsManager->executeQuery($vidQuery);

        // Ambil data FAQ
        $faqQuery = "SELECT question, answer 
        FROM Product_faq 
        WHERE id_product = '".$this->dispatcher->getParam('id')."'";
        $faqs = $this->modelsManager->executeQuery($faqQuery);

        $arrdata = [];
        foreach ($product as $key => $val) {
            $minPriceQuery = "SELECT MIN(ra.publish_price) AS min_price
                      FROM Rates r
                      JOIN Rate_options ro ON ro.id_rate = r.id
                      JOIN Rate_availability ra ON ra.id_rate_opt = ro.id
                      WHERE r.product = :product_id: AND ra.publish_price > 0";
            $minPriceResult = $this->modelsManager->executeQuery($minPriceQuery, [
                'product_id' => $val->id
            ]);
            $minPublishPrice = $minPriceResult[0]['min_price'] ?? 0;

            $discounted_price = 0;

            if (!empty($val->id_rate_options) && $minPublishPrice > 0) {
                $rateOptionQuery = "SELECT ro.id
                    FROM Rates r
                    JOIN Rate_options ro ON ro.id_rate = r.id
                    JOIN Rate_availability ra ON ra.id_rate_opt = ro.id
                    WHERE r.product = :product_id: AND ra.publish_price = :min_price:
                    LIMIT 1";

                $rateOpt = $this->modelsManager->executeQuery($rateOptionQuery, [
                    'product_id' => $val->id,
                    'min_price'  => $minPublishPrice
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
                                    $discounted_price = $minPublishPrice - $hotdeal->hotdeal_value;
                                } else {
                                    $discounted_price = $minPublishPrice - ($minPublishPrice * ($hotdeal->hotdeal_value / 100));
                                }
                            }
                        }
                    }
                }
            }

            $arrdata[$val->id] = [
                'rate_option_price' => $minPublishPrice,
                'discounted_price'  => max($discounted_price, 0),
                'min_publish_price' => $minPublishPrice
            ];
        }

        $page = $this->dispatcher->getParam('page', 'int', 1);
        $star = $this->dispatcher->getParam('star', 'int', null);
        $sort = $this->dispatcher->getParam('sort', 'string');

        // print_r('sort = '.$sort. '|   orderby = '.$orderBy);die('x');

        $perPage = 4;
        $offset = ($page - 1) * $perPage;

        if($star == null){

            if($sort == 'highest'){
                $order = 'review_star DESC';
            } else if($sort == 'lowest'){
                $order = 'review_star ASC';
            } else if($sort == 'latest'){
                $order = 'created_at DESC';
            } else if($sort == 'oldest'){
                $order = 'created_at ASC';
            } else {
                $order = 'created_at DESC';
            }

            $qr = sprintf(
                    "SELECT * FROM Product_reviews 
                    WHERE product_id = :id: AND parent_id = 0
                    ORDER BY ".$order."
                    LIMIT %d OFFSET %d",
                    $perPage,
                    $offset
                );
    
            $rev = $this->modelsManager->executeQuery($qr, [
                'id' => $this->dispatcher->getParam('id')
            ]);
    
    
            $reviewer = Product_reviews::count([
                'conditions' => 'product_id = :id: AND parent_id = 0',
                'bind' => [
                    'id' => $this->dispatcher->getParam('id'),
                ],
            ]);
            } else {
                if($sort == 'highest'){
                    $order = 'review_star DESC';
                } else if($sort == 'lowest'){
                    $order = 'review_star ASC';
                } else if($sort == 'latest'){
                    $order = 'created_at DESC';
                } else if($sort == 'oldest'){
                    $order = 'created_at ASC';
                } else {
                    $order = 'created_at DESC';
                }

                $qr = sprintf(
                    "SELECT * FROM Product_reviews 
                    WHERE product_id = :id: AND review_star = :star: AND parent_id = 0
                    ORDER BY ".$order."
                    LIMIT %d OFFSET %d",
                    $perPage,
                    $offset
                );
        
                $rev = $this->modelsManager->executeQuery($qr, [
                    'id' => $this->dispatcher->getParam('id'),
                    'star' => $star,
                ]);
        
        
        
                $reviewer = Product_reviews::count([
                    'conditions' => 'product_id = :id: AND review_star = :star: AND parent_id = 0',
                    'bind' => [
                        'id' => $this->dispatcher->getParam('id'),
                        'star' => $star,
                    ],
                ]);
            }

            function getRandomColor() {
                $r = dechex(rand(0, 255));
                $g = dechex(rand(0, 255));
                $b = dechex(rand(0, 255));

                // Pastikan dua digit
                return '#' . str_pad($r, 2, '0', STR_PAD_LEFT)
                        . str_pad($g, 2, '0', STR_PAD_LEFT)
                        . str_pad($b, 2, '0', STR_PAD_LEFT);
            }

            $reviews = [];

            foreach ($rev as $r) {
                $rp = Order_details::findFirst([
                    'conditions' => 'id = :id:',
                    'bind' => ['id' => $r->order_detail_id],
                ]);

                $rate_name = $rp->rate_name ?? '';
                $rate_opt_name = $rp->rate_opt_name ?? '';

                // Ambil gambar review utama
                $reviewImages = $this->modelsManager->executeQuery("
                    SELECT f.*
                    FROM upload_file_morph uf
                    LEFT JOIN upload_file f ON uf.upload_file_id = f.id
                    WHERE uf.related_id = :review_id:
                    AND uf.related_type = 'reviews'
                    AND uf.field = 'images'
                ", [
                    'review_id' => $r->id,
                ]);

                // Ambil video review
                $reviewVideos = $this->modelsManager->executeQuery("
                    SELECT f.*
                    FROM upload_file_morph uf
                    LEFT JOIN upload_file f ON uf.upload_file_id = f.id
                    WHERE uf.related_id = :review_id:
                    AND uf.related_type = 'reviews'
                    AND uf.field = 'videos'
                ", ['review_id' => $r->id]);

                // Ambil reply (anak dari review ini)
                $replies = Product_reviews::find([
                    'conditions' => 'parent_id = :parent_id:',
                    'bind' => ['parent_id' => $r->id],
                    'order' => 'created_at ASC'
                ]);

                $formattedReplies = [];
                foreach ($replies as $reply) {
                    $replyImages = $this->modelsManager->executeQuery("
                        SELECT f.*
                        FROM upload_file_morph uf
                        LEFT JOIN upload_file f ON uf.upload_file_id = f.id
                        WHERE uf.related_id = :review_id:
                        AND uf.related_type = 'reviews'
                        AND uf.field = 'images'
                    ", [
                        'review_id' => $reply->id,
                    ]);

                    $replyVideos = $this->modelsManager->executeQuery("
                        SELECT f.*
                        FROM upload_file_morph uf
                        LEFT JOIN upload_file f ON uf.upload_file_id = f.id
                        WHERE uf.related_id = :review_id:
                        AND uf.related_type = 'reviews'
                        AND uf.field = 'videos'
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
                        'avatar_color'   => getRandomColor(),
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
                    'avatar_color'   => getRandomColor(),
                    'images'         => $reviewImages,
                    'videos'         => $reviewVideos,
                    'replies'        => $formattedReplies,
                ];
            }

        
        // print_r($reviews);die('x');
        
        $totalPages = ceil($reviewer / $perPage);

        $baseUrl = $product[0]->id . '/' . $product[0]->slug;
        $isReviewTab = strpos($this->request->getURI(), '/review/') !== false;

        // Set data untuk view
        if (count($product) > 0) {
            $this->view->setVar('product', $product[0]);
            $this->view->setVar('images', $images);  // Mengirim maksimal 4 gambar produk ke view
            $this->view->setVar('video', $video);
            $this->view->setVar('faqs', $faqs);
            $this->view->setVar('hotdeals', $arrdata);
            $this->view->setVar('review', $reviews);
            $this->view->setVar('total_review', $totalReviews);
            $this->view->setVar('average_rating', $averageRating);
            $this->view->setVar('currentPage', $page);  
            $this->view->setVar('selectedStar', $star);
            $this->view->setVar('selectedSort', $sort);
            $this->view->setVar('totalPages', $totalPages);
            $this->view->setVar('reviewTabActive', $isReviewTab);
            $this->view->setVar('baseUrl', $baseUrl);
            $this->view->setVar('perPage', $perPage);
            $this->view->setVar('reviews', $reviews);
            $this->view->setVar('picUrl', $this->config->vars->picUrl); 
        } else {
            // Jika produk tidak ditemukan
            $this->flashSession->error("Produk tidak ditemukan.");
            return $this->response->redirect('product/index');
        }
        $this->tag->setTitle($product[0]['page_title']);
        $this->view->setVar('metadesc',$product[0]['metadata']);

        $listFAQ = [];
        // Prepare structured data (JSON-LD)
        foreach($faqs as $faq){
            $listFAQ[] = [
                "@type" => "Question",
                "name" => $faq->question,
                "acceptedAnswer" => [
                    "@type" => "Answer",
                    "text" => $faq->answer
                ]
            ];
        }

        // Prepare image URLs array for Product schema
        $imageUrls = [];
        if (isset($images) && is_array($images)) {
            foreach ($images as $pic) {
                $imageUrls[] = "{$this->config->vars->picUrl}/products/{$product[0]['id']}/{$pic->name}";
            }
        } else {
            // Fallback to single picture if 'pictures' array not available
            $imageUrls[] = "{$this->config->vars->picUrl}/products/{$product[0]['id']}/{$product[0]['picture']}";
        }

        // Prepare ImageObject schemas for each image
        $imageObjects = [];
        foreach ($images as $index => $url) {
            $imageObjects[] = [
                "@type" => "ImageObject",
                "@id" => "https://www.tropialis.com/{$product[0]['id']}/{$product[0]['slug']}/",
                "url" => "{$this->config->vars->picUrl}/products/{$product[0]['id']}/{$url->name}",
                "name" => $product[0]['name'] . " - Image {$url->name}",
                "caption" => $product[0]['name'],
                "description" => "Image of " . $product[0]['name'],
                // Add width, height, thumbnail if available in your data
                // "width" => $product[0]['image_width'][$index] ?? null,
                // "height" => $product[0]['image_height'][$index] ?? null,
                // "thumbnail" => $product[0]['image_thumbnail'][$index] ?? null,
            ];
        }

        // Prepare Review schemas for product reviews
        $reviewObjects = [];
        if (isset($reviews) && is_array($reviews)) {
            foreach ($reviews as $index => $review) {
                $reviewObjects[] = [
                    "@type" => "Review",
                    "@id" => "https://www.tropialis.com/{$product[0]['id']}/{$product[0]['slug']}/#review-content",
                    "author" => [
                        "@type" => "Person",
                        "name" => $review['review_name'] ?? "Anonymous"
                    ],
                    "reviewRating" => [
                        "@type" => "Rating",
                        "ratingValue" => $product[0]['average_rating'] ?? 5,
                        "bestRating" => 5
                    ],
                    "reviewBody" => $review['review_comment'] ?? "",
                    "datePublished" => $review['created_at'] ?? date('Y-m-d'),
                    // Optionally add more fields like "name" for review title
                    // "name" => $review['title'] ?? "Product Review"
                ];
            }
        }


        // Prepare VideoObject schemas for product videos
        $videoObjects = [];
        if (isset($video) && is_array($video)) {
            foreach ($video as $index => $vid) {
                $videoObjects[] = [
                    "@type" => "VideoObject",
                    "@id" => "https://www.tropialis.com/{$product[0]['id']}/{$product[0]['slug']}/",
                    "name" => $product[0]['name'] . " - Video {$product[0]['name']}",
                    "description" => $vid['description'] ?? "Video of {$product[0]['name']}",
                    "thumbnailUrl" => $vid['name'] ?? $imageUrls[0] ?? "",  // Use first image as thumbnail if not specified
                    "uploadDate" => $vid['created_at'] ?? date('Y-m-d'),
                    "duration" => null,  // e.g., "PT1M30S" for ISO 8601 duration
                    "url" => $this->config->vars->picUrl . "/products/" . $product[0]['id'] . "/" . $vid['name'] ?? "",
                    "embedUrl" => $this->config->vars->picUrl . "/products/" . $images[0]['name'] ?? null,
                    // Add more fields if available, like "contentUrl", "interactionStatistic", etc.
                ];
            }
        }


        // Create the @graph array
        $graph = [
            [
                "@type" => "Product",
                "@id" => "https://www.tropialis.com/{$product[0]['id']}/{$product[0]['slug']}/",
                "name" => $product[0]['name'],
                "image" => $imageObjects,  // Now an array of URLs
                "description" => strip_tags($product[0]['description']),
                "brand" => [
                    "@type" => "Organization",
                    "name" => "Tropialis"
                ],
                "sku" => "{$product[0]['sku']}",
                "url" => "https://www.tropialis.com/{$product[0]['id']}/{$product[0]['slug']}/",
                "offers" => [
                    "@type" => "Offer",
                    "price" => $product[0]['price'],
                    "priceCurrency" => "IDR",
                    "availability" => "https://schema.org/InStock",
                    "url" => "https://www.tropialis.com/{$product[0]['id']}/{$product[0]['slug']}/",
                    "seller" => [
                        "@type" => "Organization",
                        "name" => "{$product[0]['provider_name']}"
                    ]
                ],
                "aggregateRating" => [
                    "@type" => "AggregateRating",
                    "ratingValue" => ($product[0]['review'] == 0 ? "5" : $product[0]['review']),
                    "reviewCount" => ($product[0]['reviewCount'] == 0 ? "1" : $product[0]['reviewCount'])
                ],
                "review" => $reviewObjects,
                "video" => $videoObjects
            ],
            [
                "@type" => "FAQPage",
                "mainEntity" => $listFAQ
            ]
        ];

        // Add ImageObject schemas to the graph
        $graph = array_merge($graph, $imageObjects);

        // Encode the JSON-LD
        $this->view->schemaJson = json_encode([
            "@context" => "https://schema.org",
            "@graph" => $graph
        ], JSON_UNSCAPED_SLASHES | JSON_PRETTY_PRINT);

        // $listFAQ = [];
        // // Prepare structured data (JSON-LD)
        // foreach($faqs as $faq){
        //     $listFAQ[] = [
        //         "@type" => "Question",
        //         "name" => $faq->question,
        //         "acceptedAnswer" => [
        //             "@type" => "Answer",
        //             "text" => $faq->answer
        //         ]
        //     ];
        // }

        // // Prepare image URLs array for Product schema
        // $imageUrls = [];
        // if (isset($product[0]['pictures']) && is_array($product[0]['pictures'])) {
        //     foreach ($product[0]['pictures'] as $pic) {
        //         $imageUrls[] = "https://files.tropialis.com/products/{$product[0]['id']}/{$pic}";
        //     }
        // } else {
        //     // Fallback to single picture if 'pictures' array not available
        //     $imageUrls[] = "https://files.tropialis.com/products/{$product[0]['id']}/{$product[0]['picture']}";
        // }

        // // Prepare ImageObject schemas for each image
        // $imageObjects = [];
        // foreach ($imageUrls as $index => $url) {
        //     $imageObjects[] = [
        //         "@type" => "ImageObject",
        //         "@id" => "https://www.tropialis.com/{$product[0]['id']}/{$product[0]['slug']}/#image{$index}",
        //         "url" => $url,
        //         "name" => $product[0]['name'] . " - Image " . ($index + 1),
        //         "caption" => $product[0]['name'],
        //         "description" => "Image of " . $product[0]['name'],
        //         // Add width, height, thumbnail if available in your data
        //         // "width" => $product[0]['image_width'][$index] ?? null,
        //         // "height" => $product[0]['image_height'][$index] ?? null,
        //         // "thumbnail" => $product[0]['image_thumbnail'][$index] ?? null,
        //     ];
        // }

        // // Prepare Review schemas for product reviews
        // $reviewObjects = [];
        // if (isset($product[0]['reviews']) && is_array($product[0]['reviews'])) {
        //     foreach ($product[0]['reviews'] as $index => $review) {
        //         $reviewObjects[] = [
        //             "@type" => "Review",
        //             "@id" => "https://www.tropialis.com/{$product[0]['id']}/{$product[0]['slug']}/#review{$index}",
        //             "author" => [
        //                 "@type" => "Person",
        //                 "name" => $review['author'] ?? "Anonymous"
        //             ],
        //             "reviewRating" => [
        //                 "@type" => "Rating",
        //                 "ratingValue" => $review['rating'] ?? 5,
        //                 "bestRating" => 5
        //             ],
        //             "reviewBody" => $review['text'] ?? "",
        //             "datePublished" => $review['date'] ?? date('Y-m-d'),
        //             // Optionally add more fields like "name" for review title
        //             // "name" => $review['title'] ?? "Product Review"
        //         ];
        //     }
        // }

        // // Create the @graph array
        // $graph = [
        //     [
        //         "@type" => "Product",
        //         "@id" => "https://www.tropialis.com/{$product[0]['id']}/{$product[0]['slug']}/",
        //         "name" => $product[0]['name'],
        //         "image" => $imageUrls,  // Now an array of URLs
        //         "description" => strip_tags($product[0]['description']),
        //         "brand" => [
        //             "@type" => "Organization",
        //             "name" => "Tropialis"
        //         ],
        //         "sku" => "{$product[0]['sku']}",
        //         "url" => "https://www.tropialis.com/{$product[0]['id']}/{$product[0]['slug']}/",
        //         "offers" => [
        //             "@type" => "Offer",
        //             "price" => $product[0]['price'],
        //             "priceCurrency" => "IDR",
        //             "availability" => "https://schema.org/InStock",
        //             "url" => "https://www.tropialis.com/{$product[0]['id']}/{$product[0]['slug']}/",
        //             "seller" => [
        //                 "@type" => "Organization",
        //                 "name" => "{$product[0]['provider_name']}"
        //             ]
        //         ],
        //         "aggregateRating" => [
        //             "@type" => "AggregateRating",
        //             "ratingValue" => $product[0]['review'],
        //             "reviewCount" => $product[0]['reviewCount']
        //         ],
        //         "review" => $reviewObjects  // Add individual reviews here
        //     ],
        //     [
        //         "@type" => "FAQPage",
        //         "mainEntity" => $listFAQ
        //     ]
        // ];

        // // Add ImageObject schemas to the graph
        // $graph = array_merge($graph, $imageObjects);

        // // Encode the JSON-LD
        // $this->view->schemaJson = json_encode([
        //     "@context" => "https://schema.org",
        //     "@graph" => $graph
        // ], JSON_UNSCAPED_SLASHES | JSON_PRETTY_PRINT);


        // $listFAQ = [];
        // // Prepare structured data (JSON-LD)
        // foreach($faqs as $faq){
        //     $listFAQ[] = [
        //         "@type" => "Question",
        //         "name" => $faq->question,
        //         "acceptedAnswer" => [
        //             "@type" => "Answer",
        //             "text" => $faq->answer
        //         ]
        //     ];
        // }
        // //create a looping item
        // $this->view->schemaJson = json_encode([
        //     "@context" => "https://schema.org",
        //     "@graph" => [
        //         [
        //             "@type" => "Product",
        //             "@id" => "https://www.tropialis.com/{$tproduct[0]['id']}/{$product[0]['slug']}/",
        //             "name" => $product[0]['name'],
        //             "image" => [
        //                 "https://files.tropialis.com/products/{$product[0]['id']}/{$product[0]['picture']}"
        //             ],
        //             "description" => strip_tags($product[0]['description']),
        //             "brand" => [
        //                 "@type" => "Organization",
        //                 "name" => "Tropialis"
        //             ],
        //             "sku" => "{$product[0]['sku']}",
        //             "url" => "https://www.tropialis.com/{$product[0]['id']}/{$product[0]['slug']}/",
        //             "offers" => [
        //                 "@type" => "Offer",
        //                 "price" => $product[0]['price'],
        //                 "priceCurrency" => "IDR",
        //                 "availability" => "https://schema.org/InStock",
        //                 "url" => "https://www.tropialis.com/{$product[0]['id']}/{$product[0]['slug']}/",
        //                 "seller" => [
        //                     "@type" => "Organization",
        //                     "name" => "{$product[0]['provider_name']}"
        //                 ]
        //             ],
        //             "aggregateRating" => [
        //                 "@type" => "AggregateRating",
        //                 "ratingValue" => $product[0]['review'],
        //                 "reviewCount" => $product[0]['reviewCount']
        //             ]
        //         ],
        //         [
        //             "@type" => "FAQPage",
        //             "mainEntity" => $listFAQ
        //         ]
        //     ]
        // ], JSON_UNSCAPED_SLASHES | JSON_PRETTY_PRINT);
        // $this->view->setVar('schemas',json_encode($schema, JSON_UNESCAPED_SLASHES | JSON_PRETTY_PRINT));

        $this->view->pick('product/detail');
    }
    
    public function loadratelistAction(){
        $headerCollection = $this->assets->collection('header');
        $headerCollection->addCss('https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css');
        $headerCollection->addCss('https://cdn.jsdelivr.net/npm/glightbox@3.0.7/dist/css/glightbox.min.css');
        $headerCollection->addCss('css/detail.css');
        
        $footerCollection = $this->assets->collection('footer');
        $footerCollection->addJs('https://cdn.jsdelivr.net/npm/flatpickr');
        $footerCollection->addJs('https://cdn.jsdelivr.net/npm/glightbox@3.0.7/dist/js/glightbox.min.js');
        $footerCollection->addJs('js/detail.js');

        extract($_POST);
        // echo "<pre>";
        // print_r($_POST);
        // echo "</pre>";
        //get product
        // $q = "SELECT r.id, r.title, r.product, p.name, p.slug, p.description FROM Rates r LEFT JOIN Products p ON p.id = r.product WHERE r.product = '".$idp."' AND r.id = '".$id."'";
        // $product = $this->modelsManager->executeQuery($q);
        //get rate options
        $q2 = "SELECT id, id_rate, rate_option_name, rate_option_unit, rate_option_price, start_time, end_time, step, stock, duration, min_qty, max_qty, booking_window_start, booking_window_end, start_date, end_date, rate_options_text FROM Rate_options WHERE id_rate = '".$id."'";
        $rates = $this->modelsManager->executeQuery($q2);

        $arrdata = [];
        foreach($rates as $key=>$val){
            // Ambil semua data dari Rate_availability
            $q3 = "SELECT id, module_id, id_rate_opt, date_available, time_available, day_number, publish_price, rate_status
                   FROM Rate_availability 
                   WHERE id_rate_opt = " . $val->id;
            $availabilities = $this->modelsManager->executeQuery($q3);

            $q4 = "SELECT h.hotdeal_type, h.hotdeal_value, promo_status 
                   FROM Hotdeals h 
                   WHERE FIND_IN_SET(" . $val->id . ", h.rates) > 0";
            $hotdeals = $this->modelsManager->executeQuery($q4);

            $availabilityData = [];
            $blockedDates = [];

            foreach ($availabilities as $a) {
                $q5 = "SELECT availability_id, qty_start, qty_end, publish_price
                    FROM Rate_breakdown 
                    WHERE availability_id = " . $a->id;
                $breakdowns = $this->modelsManager->executeQuery($q5);

                $breakdownData = [];
                foreach ($breakdowns as $bd) {
                    $breakdownData[] = [
                        'availability_id' => $bd->availability_id,
                        'qty_start' => $bd->qty_start,
                        'qty_end' => $bd->qty_end,
                        'publish_price' => $bd->publish_price,
                    ];
                }
                $discounted_price = $a->publish_price ?? 0;

                if (count($hotdeals) > 0) {
                    foreach ($hotdeals as $hotdeal) {
                        if ($hotdeal->promo_status == 1) {
                            if ($hotdeal->hotdeal_type == 1) {
                                $discounted_price -= $hotdeal->hotdeal_value;
                            } else {
                                $discounted_price -= ($discounted_price * ($hotdeal->hotdeal_value / 100));
                            }
                        } else {
                            $discounted_price = 0;
                        }
                    }
                } else {
                    $discounted_price = 0;
                }

                $availabilityData[] = [
                    'id' => $a->id,
                    'module_id' => $a->module_id,
                    'id_rate_opt' => $a->id_rate_opt,
                    'date_available' => $a->date_available,
                    'day_number' => $a->day_number,
                    'publish_price' => $a->publish_price,
                    'discounted_price' => $discounted_price,
                    'rate_status' => $a->rate_status,
                    'time_available' => $a->time_available,
                    'breakdown'        => $breakdownData
                ];


                // Cek apakah status = 1 (diblokir)
                if ($a->rate_status == 1) {
                    $blockedDates[] = $a->date_available;
                }
            }

            $bookingWindowEnd = (int)$val->booking_window_end;
            $minDate = date('Y-m-d', strtotime('+' . $bookingWindowEnd . ' minutes'));

            $imagesQuery = "SELECT f.name FROM Upload_file_morph uf 
                        LEFT JOIN Upload_file f ON uf.upload_file_id = f.id 
                        WHERE uf.related_id = '".$val->id."' 
                        AND uf.related_type = 'rate_options' AND uf.field = 'images'";  
            $imagesResult = $this->modelsManager->executeQuery($imagesQuery);
            $images = [];
            foreach ($imagesResult as $img) {
                $images[] = $img->name;
            }

            array_push($arrdata,[
                'id_product' => $idp,
                'id' => $val['id'],
                'id_rate' => $val['id_rate'],
                'rate_option_name' => $val['rate_option_name'],
                'rate_option_unit' => $val['rate_option_unit'],
                // 'rate_option_price' => $val['rate_option_price'],
                // 'start_time' => $val['start_time'],
                // 'end_time' => $val['end_time'],
                'step' => $val['step'],
                'stock' => $val['stock'],
                'duration' => $val['duration'],
                'min_qty' => $val['min_qty'],
                'max_qty' => $val['max_qty'],
                // 'booking_window_start' => $val['booking_window_start'],
                'booking_window_end' => $bookingWindowEnd,
                'min_date' => $minDate,
                'start_date' => $val['start_date'],
                'end_date' => $val['end_date'],
                'rate_option_text' => trim(strip_tags($val['rate_options_text'])),
                'availability_data' => $availabilityData,
                'image' => $images,
                'blocked_dates' => $blockedDates ?: [],
                'discounted_price' => $discounted_price ?? 0
            ]);
        }
        return json_encode($arrdata);
        $this->view->disable();
    }

    public function availabilityAction()
{
    $headerCollection = $this->assets->collection('header');
        $headerCollection->addCss('https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css');
        $headerCollection->addCss('https://cdn.jsdelivr.net/npm/glightbox@3.0.7/dist/css/glightbox.min.css');
        $headerCollection->addCss('css/detail.css');
        
        $footerCollection = $this->assets->collection('footer');
        $footerCollection->addJs('https://cdn.jsdelivr.net/npm/flatpickr');
        $footerCollection->addJs('https://cdn.jsdelivr.net/npm/glightbox@3.0.7/dist/js/glightbox.min.js');
        $footerCollection->addJs('js/detail.js');

    extract($_POST);
    $q = "SELECT r.id, r.title, r.product, p.name, p.slug, p.description 
          FROM Rates r 
          LEFT JOIN Products p ON p.id = r.product 
          WHERE r.product = '" . $id . "'";
    $product = $this->modelsManager->executeQuery($q);
    $arrdata = [];

    foreach ($product as $rate) {
        // Ambil rate options
        $q2 = "SELECT id, id_rate, rate_option_name, rate_option_unit, rate_option_price, start_time, end_time, step, duration, min_qty, max_qty, booking_window_end, start_date, end_date, stock, rate_options_text  
               FROM Rate_options 
               WHERE id_rate = '" . $rate['id'] . "'";
        $rates = $this->modelsManager->executeQuery($q2);

        $ratesData = [];
        foreach ($rates as $r) {
            // Ambil semua data dari Rate_availability
            $q3 = "SELECT id, module_id, id_rate_opt, date_available, time_available, day_number, publish_price, rate_status
                   FROM Rate_availability 
                   WHERE id_rate_opt = " . $r->id;
            $availabilities = $this->modelsManager->executeQuery($q3);

            $q4 = "SELECT h.hotdeal_type, h.hotdeal_value, promo_status 
                   FROM Hotdeals h 
                   WHERE FIND_IN_SET(" . $r->id . ", h.rates) > 0";
            $hotdeals = $this->modelsManager->executeQuery($q4);

            $availabilityData = [];
            $blockedDates = [];

            foreach ($availabilities as $a) {

                $q5 = "SELECT availability_id, qty_start, qty_end, publish_price
                    FROM Rate_breakdown 
                    WHERE availability_id = " . $a->id;
                $breakdowns = $this->modelsManager->executeQuery($q5);

                $breakdownData = [];
                foreach ($breakdowns as $bd) {
                    $breakdownData[] = [
                        'availability_id' => $bd->availability_id,
                        'qty_start' => $bd->qty_start,
                        'qty_end' => $bd->qty_end,
                        'publish_price' => $bd->publish_price,
                    ];
                }
                $discounted_price = $a->publish_price ?? 0;

                if (count($hotdeals) > 0) {
                    foreach ($hotdeals as $hotdeal) {
                        if ($hotdeal->promo_status == 1) {
                            if ($hotdeal->hotdeal_type == 1) {
                                $discounted_price -= $hotdeal->hotdeal_value;
                            } else {
                                $discounted_price -= ($discounted_price * ($hotdeal->hotdeal_value / 100));
                            }
                        } else {
                            $discounted_price = 0;
                        }
                    }
                } else {
                    $discounted_price = 0;
                }

                $availabilityData[] = [
                    'id' => $a->id,
                    'module_id' => $a->module_id,
                    'id_rate_opt' => $a->id_rate_opt,
                    'date_available' => $a->date_available,
                    'day_number' => $a->day_number,
                    'publish_price' => $a->publish_price,
                    'discounted_price' => $discounted_price,
                    'rate_status' => $a->rate_status,
                    'time_available' => $a->time_available,
                    'breakdown'        => $breakdownData
                ];


                // Cek apakah status = 1 (diblokir)
                if (
                    $a->rate_status == 1 ||
                    ($a->module_id == 9 && $r->stock == 0)
                ) {
                    $blockedDates[] = $a->date_available;
                }
                
            }

            $bookingWindowEnd = (int)$r->booking_window_end;
            $minDate = date('Y-m-d', strtotime('+' . $bookingWindowEnd . ' minutes'));

            $imagesQuery = "SELECT f.name FROM Upload_file_morph uf 
                        LEFT JOIN Upload_file f ON uf.upload_file_id = f.id 
                        WHERE uf.related_id = '".$r->id."' 
                        AND uf.related_type = 'rate_options' AND uf.field = 'images'";  
            $imagesResult = $this->modelsManager->executeQuery($imagesQuery);
            $images = [];
            foreach ($imagesResult as $img) {
                $images[] = $img->name;
            }

            $ratesData[] = [
                'id' => $r->id,
                'id_rate' => $r->id_rate,
                'rate_option_name' => $r->rate_option_name,
                'rate_option_unit' => $r->rate_option_unit,
                'rate_option_price' => $r->rate_option_price, // Harga asli
                'discounted_price' => $discounted_price,
                // 'start_time' => $r->start_time,
                // 'end_time' => $r->end_time,
                'step' => $r->step,
                'duration' => $r->duration,
                'min_qty' => $r->min_qty,
                'max_qty' => $r->max_qty,
                'booking_window_end' => $bookingWindowEnd,
                'min_date' => $minDate,
                'start_date' => $r->start_date,
                'end_date' => $r->end_date,
                'stock' => $r->stock,
                'rate_option_text' => trim(strip_tags($r->rate_options_text)),
                'image' => $images,
                'blocked_dates' => $blockedDates ?: [],
                'availability_data' => $availabilityData
            ];
        }

        $arrdata[] = [
            'id_product' => $rate['product'],
            'id' => $rate['id'],
            'title' => $rate['title'],
            'name' => $rate['name'],
            'description' => substr($rate['description'], 0, 250) . '...',
            'rates' => $ratesData,
        ];
    }

    return json_encode($arrdata);
}


}