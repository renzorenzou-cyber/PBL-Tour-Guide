<?php
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\SMTP;
use PHPMailer\PHPMailer\Exception;
use Google\Client;

class AccountController extends ControllerBase
{

    public function ordersAction()
{
    $this->tag->setTitle('Customer Dashboard');

    $this->assets->collection('header')
        ->addCss('css/orders.css')
        ->addCss('css/navbar.css')
        ->addCss('https://unpkg.com/filepond@^4/dist/filepond.css')
        ->addCss('https://cdn.jsdelivr.net/npm/@fancyapps/ui/dist/fancybox.css')
        ->addCss('https://cdn.jsdelivr.net/npm/swiper/swiper-bundle.min.css')
        ->addCss('https://unpkg.com/filepond-plugin-image-preview/dist/filepond-plugin-image-preview.css');

    $this->assets->collection('footer')
        ->addJs('https://cdn.jsdelivr.net/npm/sweetalert2@11')
        ->addJs('https://unpkg.com/filepond@^4/dist/filepond.js')
        ->addJs('https://unpkg.com/filepond-plugin-image-preview/dist/filepond-plugin-image-preview.js')
		->addJs('https://cdn.jsdelivr.net/npm/swiper/swiper-bundle.min.js')
        ->addJs('https://unpkg.com/filepond-plugin-file-validate-type/dist/filepond-plugin-file-validate-type.js')
        ->addJs('https://cdn.jsdelivr.net/npm/@fancyapps/ui/dist/fancybox.umd.js')
        ->addJs('js/orders.js'); 


    if (!$this->session->get('trop_auth')) {
        return $this->response->redirect('account/login');
    }

    $auth = $this->session->get('trop_auth');
    $customer_id = $auth['customer_id'];
    $customer_email = $auth['customer_email'];

    // Ambil customer
    $customer = Customers::findFirst([
        'conditions' => 'id = :id:',
        'bind' => ['id' => $customer_id],
    ]);

    // Ambil gambar profil
    $imagesQuery = "
        SELECT f.name AS picture 
        FROM Upload_file_morph uf 
        LEFT JOIN Upload_file f ON uf.upload_file_id = f.id 
        WHERE uf.related_id = :id: AND uf.related_type = 'customers' 
        LIMIT 1
    ";
    $images = $this->modelsManager->executeQuery($imagesQuery, ['id' => $customer_id]);

    // Ambil semua order ID milik customer yang status = 'new and reviewed'
    $orders = Orders::find([
        'conditions' => 'customer_email = :email: AND status IN ({statuses:array})',
        'bind' => [
            'email' => $customer_email,
            'statuses' => ['new', 'reviewed'],
        ],
    ]);

    $orderIds = [];
    foreach ($orders as $order) {
        $orderIds[] = $order->id;
    }

    // Kalau tidak ada order, langsung kirim kosong ke view
    if (empty($orderIds)) {
        $this->view->setVars([
            'orders' => [],
            'totalPages' => 0,
            'currentPage' => 1,
            'images' => $images,
            'customer' => $customer,
        ]);
        return $this->view->pick('account/orders');
    }

    // Hitung total Order_details dari semua orders tersebut
    $totalOrders = Order_details::count([
        'conditions' => 'detail_status IN ({statuses:array}) AND order_id IN ({ids:array})',
        'bind' => [
            'statuses' => ['new', 'reviewed'],
            'ids' => $orderIds,
        ],
    ]);

    $perPage = 2;
    $totalPages = ceil($totalOrders / $perPage);
    $currentPage = $this->request->getQuery('page', 'int', 1);
    $offset = ($currentPage - 1) * $perPage;

    // Ambil data order_detail dengan pagination
    $orderDetails = Order_details::find([
        'conditions' => 'detail_status IN ({statuses:array}) AND order_id IN ({ids:array})',
        'bind' => [
            'statuses' => ['new', 'reviewed'],
            'ids' => $orderIds,
        ],
        'order' => 'id DESC',
        'limit' => $perPage,
        'offset' => $offset,
    ]);

    $orderData = [];
    $reviewStats = [];
    foreach ($orderDetails as $detail) {
        $order = Orders::findFirstById($detail->order_id);
        $product = Products::findFirstById($detail->product);
        $provider = Providers::findFirstById($detail->provider);

        // Ambil gambar produk
        $pixQuery = "
            SELECT f.name 
            FROM Upload_file f 
            LEFT JOIN Upload_file_morph uf ON uf.upload_file_id = f.id AND uf.related_type = 'products' 
            WHERE uf.related_id = :pid: 
            LIMIT 1
        ";
        $pix = $this->modelsManager->executeQuery($pixQuery, ['pid' => $product->id]);
        $product_pix = isset($pix[0]['name']) ? $pix[0]['name'] : '';

        $activityDate = new \DateTime($detail->order_date);
        $cutoffTime = (clone $activityDate)->modify('-24 hours');
        $now = new \DateTime();

        $cancelAllowed = $now < $cutoffTime;
        // print_r($cancelAllowed);die();

         $alreadyReviewed = Product_reviews::findFirst([
            'conditions' => 'order_detail_id = :odid:',
            'bind' => ['odid' => $detail->id]
        ]);

        $detail->already_reviewed = $alreadyReviewed ? true : false;

        // print_r($reviewedtotalPages);die();


        $orderData[] = [
            'order_placed' => $order->created_at,
            'order_detail_id' => $detail->id,
            'is_reviewed' => $detail->detail_status,
            'activity_date' => $detail->order_date,
            'sub_total' => (float)$detail->subtotal_price,
            'rate' => $detail->rate_name,
            'rateopt' => $detail->rate_opt_name,
            'module' => $detail->module,
            'days' => $detail->order_days,
            'qty' => (float)$detail->quantity,
            'order_code' => $order->code,
            'order_status' => $order->status,
            'product_image' => $product_pix,
            'product_id' => $product->id,
            'product_name' => $product->name,
            'product_url' => $product->slug,
            'provider_name' => $provider ? $provider->name : '',
            'cancel_allowed' => $cancelAllowed,
            'check' => $detail->already_reviewed, 
        ];

       $reviewer = Product_reviews::count([
            'conditions' => 'product_id = :id: AND parent_id = 0',
            'bind' => [
                'id' => $product->id,
            ],
        ]);

        $rev = Product_reviews::find([
            'conditions' => 'product_id = :id:',
            'bind' => ['id' => $product->id],
        ]);

        $totalStars = 0;
        if ($reviewer > 0) {
            foreach ($rev as $r) {
                $totalStars += $r->review_star;
            }
            $averageRating = number_format($totalStars / $reviewer, 1);
        } else {
            $averageRating = 0;
        }

        $reviewStats[$product->id] = [
            'total_review'   => $reviewer,
            'average_rating' => $averageRating,
        ];

    }

    // ambil data reviewed
    $totalReviewedOrders = Order_details::count([
        'conditions' => 'detail_status = :status: AND order_id IN ({ids:array})',
        'bind' => [
            'status' => 'reviewed',
            'ids' => $orderIds,
        ],
    ]);

    $reviewedperPage = 2;
    $reviewedtotalPages = ceil($totalReviewedOrders / $reviewedperPage);
    $reviewedcurrentPage = $this->dispatcher->getParam('page', 'int', 1);
    $reviewedoffset = ($reviewedcurrentPage - 1) * $reviewedperPage;


    // Ambil data reviewed dengan pagination
    $reviewedorderDetails = Order_details::find([
        'conditions' => 'detail_status = :status: AND order_id IN ({ids:array})',
        'bind' => [
            'status' => 'reviewed',
            'ids' => $orderIds,
        ],
        'order' => 'id DESC',
        'limit' => $reviewedperPage,
        'offset' => $reviewedoffset,
    ]);

    $reviewedData = [];
    $reviewed = [];
    foreach ($reviewedorderDetails as $detail) {
        $order = Orders::findFirstById($detail->order_id);
        $product = Products::findFirstById($detail->product);
        $provider = Providers::findFirstById($detail->provider);

        // Ambil gambar produk
        $pixQuery = "
            SELECT f.name 
            FROM Upload_file f 
            LEFT JOIN Upload_file_morph uf ON uf.upload_file_id = f.id AND uf.related_type = 'products' 
            WHERE uf.related_id = :pid: 
            LIMIT 1
        ";
        $pix = $this->modelsManager->executeQuery($pixQuery, ['pid' => $product->id]);
        $product_pix = isset($pix[0]['name']) ? $pix[0]['name'] : '';

        // print_r($reviewedtotalPages);die();


        $reviewedData[] = [
            'order_placed' => $order->created_at,
            'order_detail_id' => $detail->id,
            'is_reviewed' => $detail->detail_status,
            'activity_date' => $detail->order_date,
            'sub_total' => (float)$detail->subtotal_price,
            'rate' => $detail->rate_name,
            'rateopt' => $detail->rate_opt_name,
            'module' => $detail->module,
            'days' => $detail->order_days,
            'qty' => (float)$detail->quantity,
            'order_code' => $order->code,
            'order_status' => $order->status,
            'product_image' => $product_pix,
            'product_id' => $product->id,
            'product_name' => $product->name,
            'product_url' => $product->slug,
            'provider_name' => $provider ? $provider->name : '', 
        ];

       $reviewer = Product_reviews::count([
            'conditions' => 'order_detail_id = :id: AND parent_id = 0',
            'bind' => [
                'id' => $detail->id,
            ],
        ]);

        $rev = Product_reviews::find([
            'conditions' => 'order_detail_id = :id:',
            'bind' => ['id' => $detail->id],
        ]);

        foreach ($rev as $r) {
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
            
            $reviewed[$detail->id] = [
                'review_id'      => $r->id,
                'star'   => $r->review_star,
                'comment' => $r->review_comment,
                'rate_name'      => $rate_name,
                'rate_opt_name'  => $rate_opt_name,
                'product_name'   => $product_name,
                'formatted_date' => date('d F Y', strtotime($r->created_at)),
                'images'         => $reviewImages,
                'videos'         => $reviewVideos,
            ];
        }


    }

    $q = "SELECT country_id, iso2, short_name FROM Countries ORDER BY short_name ASC";
        $countries = $this->modelsManager->executeQuery($q);
        $this->view->setVar('countries',$countries);

    // cancelled order data
    $cancelledPage = $this->dispatcher->getParam('page', 'int', 1);
    $cancelledoffset = ($cancelledPage - 1) * $perPage;

    // Ambil semua order ID milik customer yang status = 'cancelled'
    $allOrders = Orders::find([
        'conditions' => 'customer_email = :email:',
        'bind' => [
            'email' => $customer_email,
        ],
    ]);

    $allOrderIds = [];
    foreach ($allOrders as $o) {
        $allOrderIds[] = $o->id;
    }


    $cancelled = Order_details::find([
        'conditions' => 'detail_status = :status: AND order_id IN ({ids:array})',
        'bind' => [
            'status' => 'cancelled',
            'ids' => $allOrderIds,
        ],
        'order' => 'id DESC',
        'limit' => $perPage,
        'offset' => $cancelledoffset,
    ]);

    $totalCancelled = Order_details::count([
        'conditions' => 'detail_status = :status: AND order_id IN ({ids:array})',
        'bind' => [
            'status' => 'cancelled',
            'ids' => $allOrderIds,
        ],
    ]);

    $cancelledTotalPages = ceil($totalCancelled / $perPage);
    // echo "<pre>";
    // print_r($totalCancelled);
    // echo "</pre>";
    // die();

    $cancelledData = [];
    foreach ($cancelled as $cancel) {
        $order = Orders::findFirstById($cancel->order_id);
        $product = Products::findFirstById($cancel->product);
        $provider = Providers::findFirstById($cancel->provider);

        // Ambil gambar produk
        $pixQuery = "
            SELECT f.name 
            FROM Upload_file f 
            LEFT JOIN Upload_file_morph uf ON uf.upload_file_id = f.id AND uf.related_type = 'products' 
            WHERE uf.related_id = :pid: 
            LIMIT 1
        ";
        $pix = $this->modelsManager->executeQuery($pixQuery, ['pid' => $product->id]);
        $product_pix = isset($pix[0]['name']) ? $pix[0]['name'] : '';

        $cancelledData[] = [
            'order_placed' => $order->created_at,
            'order_detail_id' => $cancel->id,
            'activity_date' => $cancel->order_date,
            'sub_total' => (float)$cancel->subtotal_price,
            'rate' => $cancel->rate_name,
            'rateopt' => $cancel->rate_opt_name,
            'module' => $cancel->module,
            'days' => $cancel->order_days,
            'qty' => (float)$cancel->quantity,
            'order_code' => $order->code,
            'order_status' => $order->status,
            'product_image' => $product_pix,
            'product_id' => $product->id,
            'product_name' => $product->name,
            'product_url' => $product->slug,
            'provider_name' => $provider ? $provider->name : '',
        ];

    }

    // wishlist data
    $wishlistPage = $this->dispatcher->getParam('page', 'int', 1);
    $wishlistPerPage = 3;
    $wishlistoffset = ($wishlistPage - 1) * $wishlistPerPage;
    $wishlistProductIds = [];

	if ($this->session->has('trop_auth')) {
		$cus_email = $this->session->get('trop_auth')['customer_email'];

		$wishlistId = Wishlist::findFirst([
			'conditions' => 'customer_email = :email:',
			'bind' => ['email' => $cus_email],
		]);

        $wishlistItems = Wishlist_detail::find([
            'conditions' => 'id_wishlist = :id:',
			'bind' => ['id' => $wishlistId->id],
        ]);

		foreach ($wishlistItems as $item) {
			$wishlistProductIds[] = $item->id_product;
		}
	}

    if($wishlistProductIds){

        $wishlistProduct = Products::find([
            'conditions' => 'id IN ({ids:array})',
            'bind' => [
                'ids' => $wishlistProductIds,
            ],
            'limit' => $wishlistPerPage,
            'offset' => $wishlistoffset,
        ]);
    
        $totalWishlist = Products::count([
            'conditions' => 'id IN ({ids:array})',
            'bind' => [
                'ids' => $wishlistProductIds,
            ],
        ]);
    
        $wishlistTotalPages = ceil($totalWishlist / $wishlistPerPage);
        // echo "<pre>";
        // print_r($wishlistProductIds);
        // echo "</pre>";
        // die();
    
        $wishlistData = [];
        foreach ($wishlistProduct as $wishlist) {
            $product = Products::findFirstById($wishlist->id);

            $minPriceQuery = "SELECT MIN(ra.publish_price) AS min_price
					FROM Rates r
					JOIN Rate_options ro ON ro.id_rate = r.id
					JOIN Rate_availability ra ON ra.id_rate_opt = ro.id
					WHERE r.product = :product_id: AND ra.publish_price > 0";
				$minPriceResult = $this->modelsManager->executeQuery($minPriceQuery, [
					'product_id' => $wishlist->id
				]);
				$minPublishPrice = $minPriceResult[0]['min_price'] ?? 0;

				$discounted_price = $minPublishPrice;
				$rate_option_price = $minPublishPrice;

				$rateOptionQuery = "SELECT ro.id
					FROM Rates r
					JOIN Rate_options ro ON ro.id_rate = r.id
					JOIN Rate_availability ra ON ra.id_rate_opt = ro.id
					WHERE r.product = :product_id: AND ra.publish_price = :min_price:
					LIMIT 1";
				$rateOpt = $this->modelsManager->executeQuery($rateOptionQuery, [
					'product_id' => $wishlist->id,
					'min_price' => $minPublishPrice
				])->getFirst();

				if ($rateOpt) {
					$hotdealQuery = "SELECT hotdeal_type, hotdeal_value, promo_status
						FROM Hotdeals
						WHERE FIND_IN_SET(:rate_option_id:, rates) > 0";
					$hotdeal = $this->modelsManager->executeQuery($hotdealQuery, [
						'rate_option_id' => $rateOpt->id
					])->getFirst();

					if ($hotdeal && $hotdeal->promo_status == 1) {
						if ($hotdeal->hotdeal_type == 1) {
							$discounted_price = $minPublishPrice - $hotdeal->hotdeal_value;
						} else {
							$discounted_price = $minPublishPrice - ($minPublishPrice * ($hotdeal->hotdeal_value / 100));
						}
					}
				}

				$rates[$wishlist->id] = [
					'rate_option_price' => $rate_option_price,
					'discounted_price' => ($discounted_price < $minPublishPrice) ? max($discounted_price, 0) : 0,
					'min_publish_price' => $minPublishPrice,
				];

                $qr = "SELECT rev.id, rev.parent_id, rev.product_id, rev.review_star, rev.review_comment, rev.review_name, rev.review_country, rev.created_at FROM Product_reviews rev WHERE product_id = '".$wishlist->id."' AND rev.parent_id = 0 ORDER BY rev.created_at DESC";
                $rev = $this->modelsManager->executeQuery($qr);

                $wishlistreviewer = Product_reviews::count([
                    'conditions' => 'product_id = :id: AND parent_id = 0',
                    'bind' => [
                        'id' => $wishlist->id,
                    ],
                ]);

                $wishlisttotalStars = 0;
                $wishlisttotalReviews = $wishlistreviewer;

                if ($wishlisttotalReviews > 0) {
                    foreach ($rev as $r) {
                        $wishlisttotalStars += $r->review_star;
                    }
                    $wishlistaverageRating = round($wishlisttotalStars / $wishlisttotalReviews, 1);
                } else {
                    // Fallback: review dari semua produk milik provider yang sama
                    $providerId = $wishlist->provider;

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
                        $wishlistfallbackReviews = $this->modelsManager->executeQuery($qFallback, [
                            'ids' => $providerProductIds
                        ]);

                        $wishlisttotalFallbackStars = 0;
                        $wishlisttotalFallbackReviews = count($wishlistfallbackReviews);

                        if ($wishlisttotalFallbackReviews > 0) {
                            foreach ($wishlistfallbackReviews as $fr) {
                                $wishlisttotalFallbackStars += $fr->review_star;
                            }
                            $wishlistaverageRating = round($wishlisttotalFallbackStars / $wishlisttotalFallbackReviews, 1);
                            $wishlisttotalReviews = $wishlisttotalFallbackReviews;
                        } else {
                            $wishlistaverageRating = 0;
                            $wishlisttotalReviews = 0;
                        }
                    } else {
                        $wishlistaverageRating = 0;
                        $wishlisttotalReviews = 0;
                    }
                }


                $reviewStats[$wishlist->id] = [
                    'total_review'   => $wishlisttotalReviews,
                    'average_rating' => $wishlistaverageRating,
                    'is_provider'    => ($wishlistreviewer == 0) ? true : false
                ];
    
            // Ambil gambar produk
            $pixQuery = "
                SELECT f.name 
                FROM Upload_file f 
                LEFT JOIN Upload_file_morph uf ON uf.upload_file_id = f.id AND uf.related_type = 'products' 
                WHERE uf.related_id = :pid: 
                LIMIT 1
            ";
            $pix = $this->modelsManager->executeQuery($pixQuery, ['pid' => $product->id]);
            $product_pix = isset($pix[0]['name']) ? $pix[0]['name'] : '';
    
            $wishlistData[] = [
                'module' => $cancel->module,
                'product_image' => $product_pix,
                'product_id' => $product->id,
                'product_desc' => $product->page_title,
                'product_name' => $product->name,
                'product_url' => $product->slug,
                'product_group' => $product->group_product,
                'provider_name' => $provider ? $provider->name : '',
                'ordered' => $product->ordered,
            ];
    
        }
    } else {
        $wishlistData = [];
        $wishlistTotalPages = 0;
    }


    

    




    $this->view->setVars([
        'orders' => $orderData,
        'reviewStats' => $reviewStats,
        'cancelled' => $cancelledData,
        'wishlistData' => $wishlistData,
        'totalPages' => $totalPages,
        'currentPage' => $currentPage,
        'images' => $images,
        'customer' => $customer,
        'current_path' => $this->request->getURI(),
        'cancelledTotalPages' => $cancelledTotalPages,
        'cancelledPage' => $cancelledPage,
        'wishlistTotalPages' => $wishlistTotalPages,
        'wishlistPage' => $wishlistPage,
		'wishlistreviewStats'=> $wishlistreviewStats,
		'wishlistProductIds'=> $wishlistProductIds,
        'reviewedData' => $reviewedData,
        'reviewed' => $reviewed,
        'reviewedTotalPages' => $reviewedtotalPages,
        'reviewedPage' => $reviewedcurrentPage,
		'hotdeals' => $rates,
        'picUrl' => $this->config->vars->picUrl,

    ]);

    $this->view->pick('account/orders');
}

    public function editprofilepictureAction()
{
    $this->view->disable();

    if (!isset($_FILES['avatar']) || $_FILES['avatar']['error'] !== UPLOAD_ERR_OK) {
        return $this->response->setJsonContent([
            'status' => 'danger',
            'message' => 'No file uploaded or there was an upload error.'
        ]);
    }

    $file = $_FILES['avatar'];
    $allowedExtensions = ["image/jpeg", "image/png"];
    $maxSize = 5 * 1024 * 1024; // 5MB

    if (!in_array($file['type'], $allowedExtensions)) {
        return $this->response->setJsonContent([
            'status' => 'danger',
            'message' => 'Invalid file format. Please upload a JPG or PNG file.'
        ]);
    }

    if ($file['size'] > $maxSize) {
        return $this->response->setJsonContent([
            'status' => 'danger',
            'message' => 'File size exceeds 5MB. Please upload a smaller file.'
        ]);
    }

    list($width, $height) = getimagesize($file['tmp_name']);
    $maxDimension = 400;
    if ($width > $maxDimension || $height > $maxDimension) {
        return $this->response->setJsonContent([
            'status' => 'danger',
            'message' => "Image dimensions are too large. Max allowed: {$maxDimension}x{$maxDimension}px."
        ]);
    }

    $customer_id = $this->session->get('trop_auth')['customer_id'];
    $fileName = 'customers_' . basename($file['name']);
    $relativePath = 'uploads/customers/' . $customer_id . '/' . $fileName;
    $uploadDir = '../../tropadmin/public/uploads/customers/' . $customer_id;
    $fullPath = $uploadDir . '/' . $fileName;

    if (!is_dir($uploadDir)) {
        mkdir($uploadDir, 0777, true);
    }

    // Simpan hash sebelum file dipindah
    $fileHash = md5_file($file['tmp_name']);

    if (!move_uploaded_file($file['tmp_name'], $fullPath)) {
        return $this->response->setJsonContent([
            'status' => 'danger',
            'message' => 'Failed to upload image.'
        ]);
    }

    // Cek apakah morph-nya sudah ada
    $existingImageMorph = Upload_file_morph::findFirst([
        'conditions' => 'related_id = :customer_id: AND related_type = "customers" AND field = "image"',
        'bind' => ['customer_id' => $customer_id]
    ]);

    if ($existingImageMorph) {
        // Update file lama
        $uploadFile = Upload_file::findFirst($existingImageMorph->upload_file_id);

        // Hapus file lama secara fisik
        $oldFilePath = '../../tropadmin/public/' . $uploadFile->url;
        if (file_exists($oldFilePath)) {
            unlink($oldFilePath);
        }

        // Update data file baru
        $uploadFile->name = $fileName;
        $uploadFile->hash = $fileHash;
        $uploadFile->ext = pathinfo($file['name'], PATHINFO_EXTENSION);
        $uploadFile->mime = $file['type'];
        $uploadFile->size = number_format($file['size'], 2, '.', '');
        $uploadFile->url = $relativePath;
        $uploadFile->save();
    } else {
        // Buat file baru
        $uploadFile = new Upload_file();
        $uploadFile->name = $fileName;
        $uploadFile->hash = $fileHash;
        $uploadFile->ext = pathinfo($file['name'], PATHINFO_EXTENSION);
        $uploadFile->mime = $file['type'];
        $uploadFile->size = number_format($file['size'], 2, '.', '');
        $uploadFile->url = $relativePath;
        $uploadFile->provider = 'local';

        if (!$uploadFile->save()) {
            $messages = $uploadFile->getMessages();
            $errors = array();
            foreach ($messages as $message) {
                $errors[] = $message->getMessage();
            }

            return $this->response->setJsonContent([
                'status' => 'danger',
                'message' => 'Failed to save image data.',
                'errors' => $errors
            ]);
        }

        // Tambahkan ke morph
        $uploadFileMorph = new Upload_file_morph();
        $uploadFileMorph->upload_file_id = $uploadFile->id;
        $uploadFileMorph->related_id = $customer_id;
        $uploadFileMorph->related_type = 'customers';
        $uploadFileMorph->field = 'image';

        if (!$uploadFileMorph->save()) {
            $messages = $uploadFileMorph->getMessages();
            $errors = array();
            foreach ($messages as $message) {
                $errors[] = $message->getMessage();
            }

            return $this->response->setJsonContent([
                'status' => 'danger',
                'message' => 'Failed to save image relation.',
                'errors' => $errors
            ]);
        }
    }

    // Simpan ke session
    $cus_pict = '/customers/' . $customer_id . '/' . $fileName;
    $auth = $this->session->get('trop_auth');
    $auth['customer_picture'] = $cus_pict;
    $this->session->set('trop_auth', $auth);

    return $this->response->setJsonContent([
        'status' => 'success',
        'message' => 'Profile picture uploaded successfully.',
        'file_url' => $uploadFile->url
    ]);
}

    public function signupAction(){
        $this->tag->setTitle('Sign-up');
        $footerCollection = $this->assets->collection('footer');
        $footerCollection->addJs('https://cdn.jsdelivr.net/npm/sweetalert2@11');
        $this->view->pick('account/signup');
    }

        public function signupprocessAction(){
            extract($_POST);
            
            $cek = Customers::findFirst([
                'conditions' => 'email = :email:',
                'bind' => ['email' => $email]
            ]);
            
            
            if($cek){
                echo json_encode(['status'=>'danger', 'text'=>'Email already exist!']);
                return false;
            }else {
            
            $hash_id = bin2hex(random_bytes(20));

            // Create a new customers object
            $ins = new Customers();
            $ins->hash_id = $hash_id;
            $ins->name = $first_name . ' ' . $second_name;
            $ins->email = $email;
            $ins->phone = $phone;
            $ins->country = $country;
            $ins->password = password_hash($signup_password, PASSWORD_DEFAULT);
            $ins->customer_status = 0;  
            $ins->activation_created_at = date('Y-m-d H:i:s');
            $ins->save();

            
            // Generate the activation link with the hash_id
            $protocol = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off' || $_SERVER['SERVER_PORT'] == 443) ? "https://" : "http://";
            $host = $_SERVER['HTTP_HOST'];
            $baseUrl = $this->url->getBaseUri();
            $fullBaseUrl = $protocol . $host . $baseUrl;

            $activation_link = $fullBaseUrl . 'account/activation/' . $hash_id;

            require '../vendor/autoload.php';
            // data untuk dikirim ke mailer
            $cust_name = $ins->name;
            $cust_email = $ins->email;


                $signupActivation[] = [
                    'name' => $cust_name, 
                    'email' => $cust_email, 
                    'activation_link' => $activation_link,
                ];

            // Kirim data ke MailController
            $mailService = $this->di->get('mail');
            $result = $mailService->signupAction($signupActivation);

            echo json_encode(['status'=>'success', 'text'=>'Please Signin through the login page']);
            return false;
            }
        }

    public function activationAction($hashId){
        $footerCollection = $this->assets->collection('footer');
		$footerCollection->addJs('https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/gsap.min.js');
        $footerCollection->addJs('js/signin.js');
        $customer = Customers::findFirstByHashId($hashId);

        if ($customer) {
            if ($customer->customer_status == 1) {
                $this->flash->warning('Account already activated.');
                return $this->response->redirect('account/login/');
            }

            $createdAt = new \DateTime($customer->activation_created_at);
            $now = new \DateTime();
            $interval = $now->getTimestamp() - $createdAt->getTimestamp();

            if ($interval > 86400) {
                $this->view->setVar('email', $customer->email);
                $this->flash->error('Activation link has expired.');
                return $this->view->pick('account/activation_expired');
            }

            $customer->customer_status = 1;
            if ($customer->save()) {
                $this->flash->success('Your account has been activated successfully!');
                return $this->response->redirect('account/activation/'.$hashId.'/success');
            } else {
                $this->flash->error('Failed to activate your account.');
            }
        } else {
            $this->view->pick('account/activation_invalid');
        }

    }

    public function activationSuccessAction(){
        $this->view->pick('account/activate_acc');
    }

    public function resendactivationAction(){
        $footerCollection = $this->assets->collection('footer');
        $footerCollection->addJs('js/signin.js');
        $email = $this->request->getPost('email', 'email');

        $customer = Customers::findFirst([
            'conditions' => 'email = :email: AND customer_status = 0',
            'bind' => ['email' => $email]
        ]);

        if (!$customer) {
            return json_encode([
                'status' => 'error',
                'title' => 'Failed',
                'text' => 'Account not found or already activated.',
                'icon' => 'error'
            ]);
        }

        $lastSent = new \DateTime($customer->activation_created_at);
        $now = new \DateTime();
        $diffSeconds = $now->getTimestamp() - $lastSent->getTimestamp();

        if ($diffSeconds < 300) {
            return json_encode([
                'status' => 'warning',
                'title' => 'Please wait',
                'text' => 'Wait a few minutes before requesting again.',
                'icon' => 'warning'
            ]);
        }

        $newHash = bin2hex(random_bytes(20));
        $customer->hash_id = $newHash;
        $customer->activation_created_at = date('Y-m-d H:i:s');

        if (!$customer->save()) {
            return json_encode([
                'status' => 'error',
                'title' => 'Error',
                'text' => 'Failed to update activation link.',
                'icon' => 'error'
            ]);
        }

        require '../vendor/autoload.php';

        $protocol = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off' || $_SERVER['SERVER_PORT'] == 443) ? "https://" : "http://";
        $host = $_SERVER['HTTP_HOST'];
        $baseUrl = $this->url->getBaseUri();
        $fullBaseUrl = $protocol . $host . $baseUrl;

        $activation_link = $fullBaseUrl . 'account/activation/' . $newHash;

        $signupActivation[] = [
            'name' => $customer->name,
            'email' => $customer->email,
            'activation_link' => $activation_link,
        ];

        $mailService = $this->di->get('mail');
        $mailService->signupAction($signupActivation);

        return json_encode([
            'status' => 'success',
            'title' => 'Sent!',
            'text' => 'A new activation link has been sent to your email.',
            'icon' => 'success'
        ]);
    }

    public function loginAction(){
        $this->tag->setTitle('Login');
        $footerCollection = $this->assets->collection('footer');
        $footerCollection->addJs('https://cdn.jsdelivr.net/npm/sweetalert2@11');
		$footerCollection->addJs('js/signin.js');

        $q = "SELECT country_id, iso2, short_name FROM Countries ORDER BY short_name ASC";
        $countries = $this->modelsManager->executeQuery($q);

        $customer = $this->session->get('trop_auth');
        if($customer){
            return $this->response->redirect('account/orders');
        }
        
        $this->view->setVar('countries',$countries);

        $this->view->pick('account/login');
    }

    public function loginprocessAction(){
        $this->view->disable();
        extract($_POST);
    
        $cek = Customers::findFirst([
            'conditions' => 'email = :email:',
            'bind' => ['email' => $email]
        ]);

        if(!$cek){
            echo json_encode(['status'=>'danger', 'text'=>'Account doesn`t exist!']);
            return false;
        }

        $status = $cek->customer_status;


        $imagesQuery = "SELECT f.name as picture FROM Upload_file_morph uf 
                        LEFT JOIN Upload_file f ON uf.upload_file_id = f.id 
                        WHERE uf.related_id = ".$cek->id."
                        AND uf.related_type = 'customers' LIMIT 1"; 
        $images = $this->modelsManager->executeQuery($imagesQuery);

        $image_url = null;
        if (count($images) > 0) {
            $image_url = '/customers/' . $cek->id . '/' . $images[0]->picture;
        }        

        if ($status == '0') {
            echo json_encode(array('status'=>'warning', 'text'=>'Please activate your account.'));
        } else if (!$cek || !password_verify($password, $cek->password)){
            echo json_encode(array('status'=>'danger', 'text'=>'Please check your email or password.'));
        } else {
            $this->_registerSession($cek,$image_url);
            echo json_encode(array('status'=>'success', 'text'=>'Login successful!'));
        }
    }

    public function forgetpasswordAction(){
        $this->tag->setTitle('Forget password');
        $footerCollection = $this->assets->collection('footer');
        $footerCollection->addJs('https://cdn.jsdelivr.net/npm/sweetalert2@11');
		$footerCollection->addJs('js/forgetpass.js');
        $this->view->pick('account/forgetpassword');
    }

    public function forgetpasswordprocessAction(){
        extract($_POST);
    
        $customer = Customers::findFirst([
            'conditions' => 'email = :email:',
            'bind' => ['email' => $email]
        ]);
    
        if (!$customer) {
            echo json_encode(array('status'=>'danger', 'text'=>'Please fill the correct email.'));
        } else {
            echo json_encode(array('status'=>'success', 'text'=>'Please check your email to reset your password'));

            require '../vendor/autoload.php';

            
            $cust_name = $customer->name;
            $cust_email = $customer->email;
            $cust_hash_id = $customer->hash_id;

            // generate reset password link
            $protocol = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off' || $_SERVER['SERVER_PORT'] == 443) ? "https://" : "http://";
            $host = $_SERVER['HTTP_HOST'];
            $baseUrl = $this->url->getBaseUri();
            $fullBaseUrl = $protocol . $host . $baseUrl;

            $resetpassword = $fullBaseUrl . 'account/requestnewpassword/' . $cust_hash_id;

                $forgetpassword[] = [
                    'resetpassword' => $resetpassword,
                    'name' => $cust_name, 
                    'email' => $cust_email,
                ];

            // Kirim data ke MailController
            $mailService = $this->di->get('mail');
            $result = $mailService->forgetpasswordAction($forgetpassword);
            }
            $this->view->disable();
    }

    public function requestnewpasswordAction() {
        $this->tag->setTitle('New Password');
    
        $footerCollection = $this->assets->collection('footer');
        $footerCollection->addJs('https://cdn.jsdelivr.net/npm/sweetalert2@11');
        $footerCollection->addJs('js/forgetpass.js');
        
        $this->view->pick('account/newpassword');
    }

    public function requestnewpasswordprocessAction() {
        $footerCollection = $this->assets->collection('footer');
        $footerCollection->addJs('https://cdn.jsdelivr.net/npm/sweetalert2@11');
        $footerCollection->addJs('js/forgetpass.js');

        $password = $this->request->getPost('password');
        $hashId = $this->request->getPost('hash_id');

        // Cari customer berdasarkan hash_id
        $customer = Customers::findFirst([
            'conditions' => 'hash_id = :hash_id:',
            'bind' => ['hash_id' => $hashId]
        ]);
        

            $customer->password = password_hash($password, PASSWORD_DEFAULT);
            if ($customer->save()) {
                echo json_encode(array('status'=>'success', 'text'=>'You can now login with your new password.'));
                exit;  // Pastikan untuk menghentikan eksekusi setelah mengirimkan respons

            } else {
                echo json_encode(array('status'=>'danger', 'text'=>'Failed to update password.'));
            }
    }

    public function login_securityAction(){
        $headerCollection = $this->assets->collection('header');
        $headerCollection->addCss('css/orders.css');
        $headerCollection->addCss('css/navbar.css');

        $footerCollection = $this->assets->collection('footer');
        $footerCollection->addJs('https://cdn.jsdelivr.net/npm/sweetalert2@11');
		$footerCollection->addJs('js/orders.js');

        // profile section start
        $customer_id = $this->session->get('trop_auth')['customer_id'];

        $customer = Customers::findFirst([
            'conditions' => 'id = :id:',
            'bind' => ['id' => $customer_id],
        ]);

        $imagesQuery = "SELECT f.name as picture FROM Upload_file_morph uf 
                        LEFT JOIN Upload_file f ON uf.upload_file_id = f.id 
                        WHERE uf.related_id = ".$customer_id."
                        AND uf.related_type = 'customers' LIMIT 1"; 
        $images = $this->modelsManager->executeQuery($imagesQuery);
        // profile section end


        // orders section start
        // Ambil email customer dari session
        $customer_email = $this->session->get('trop_auth')['customer_email'];

        // Hitung total order
        $totalOrders = Orders::count([
            'conditions' => 'customer_email = :customer_email:',
            'bind' => ['customer_email' => $customer_email],
        ]);

        // Jumlah order per halaman
        $perPage = 2;

        // Hitung total halaman
        $totalPages = ceil($totalOrders / $perPage);

        // Ambil halaman saat ini dari query string
        $currentPage = $this->request->getQuery('page', 'int', 1);

        // Hitung offset
        $offset = ($currentPage - 1) * $perPage;

        // Ambil data order dengan pagination
        $orders = Orders::find([
            'conditions' => 'customer_email = :customer_email:',
            'bind' => ['customer_email' => $customer_email],
            'limit' => $perPage,
            'offset' => $offset,
        ]);

        // Inisialisasi array untuk menyimpan data order
        $orderData = [];

        foreach ($orders as $order) {
            // Ambil order detail untuk setiap order
            $orderDetail = Order_details::findFirst([
                'conditions' => 'order_id = :order_id:',
                'bind' => ['order_id' => $order->id],
            ]);

            if ($orderDetail) {
                // Ambil product detail
                $pr = Products::findFirst([
                    'conditions' => 'id = :id:',
                    'bind' => ['id' => $orderDetail->product],
                ]);

                // Ambil provider 
                $provider = Providers::findFirst([
                    'conditions' => 'id = :id:',
                    'bind' => ['id' => $orderDetail->provider],
                ]);

                $provider_name = $provider->name;

                if ($pr) {
                    $product_id = $pr->id;
                    $product_name = $pr->name;
                    $product_url = $pr->slug;
                    $product_code = $pr->sku;

                    // Ambil gambar produk
                    $q = "SELECT f.name FROM Upload_file f 
                        LEFT JOIN Upload_file_morph uf ON uf.upload_file_id = f.id AND uf.related_type = 'products' 
                        WHERE uf.related_id = '".$product_id."' LIMIT 0,1";
                    $pix = $this->modelsManager->executeQuery($q);
                    $product_pix = $pix[0]['name'];

                    // Simpan data order ke dalam array
                    $orderData[] = [
                        'order_placed' => $order->created_at,
                        'activity_date' => $orderDetail->order_date,
                        'sub_total' => (float)$orderDetail->subtotal_price,
                        'rate' => $orderDetail->rate_name,
                        'rateopt' => $orderDetail->rate_opt_name,
                        'module' => $orderDetail->module,
                        'days' => $orderDetail->order_days,
                        'qty' => (float)$orderDetail->quantity,
                        'order_code' => $order->code,
                        'order_status' => $order->status,
                        'product_image' => $product_pix,
                        'product_id' => $product_id,
                        'product_name' => $product_name,
                        'product_url' => $product_url,
                        'provider_name' => $provider_name,
                    ];
                }
            }
        }

        // Kirim data ke view
        $this->view->setVar('orders', $orderData);
        $this->view->setVar('totalPages', $totalPages);
        $this->view->setVar('currentPage', $currentPage);
        // orders section end

        $this->view->setVar('images', $images);
        $this->view->setVar('customer', $customer);

        $this->view->pick('account/login_security');
    }

    public function reviewAction(){
        $headerCollection = $this->assets->collection('header');
        $headerCollection->addCss('css/orders.css');
        $headerCollection->addCss('css/navbar.css');

        $footerCollection = $this->assets->collection('footer');
        $footerCollection->addJs('https://cdn.jsdelivr.net/npm/sweetalert2@11');
		$footerCollection->addJs('js/orders.js');

        // profile section start
        $customer_id = $this->session->get('trop_auth')['customer_id'];

        $customer = Customers::findFirst([
            'conditions' => 'id = :id:',
            'bind' => ['id' => $customer_id],
        ]);

        $imagesQuery = "SELECT f.name as picture FROM Upload_file_morph uf 
                        LEFT JOIN Upload_file f ON uf.upload_file_id = f.id 
                        WHERE uf.related_id = ".$customer_id."
                        AND uf.related_type = 'customers' LIMIT 1"; 
        $images = $this->modelsManager->executeQuery($imagesQuery);
        // profile section end


        // orders section start
        // Ambil email customer dari session
        $customer_email = $this->session->get('trop_auth')['customer_email'];

        // Hitung total order
        $totalOrders = Orders::count([
            'conditions' => 'customer_email = :customer_email:',
            'bind' => ['customer_email' => $customer_email],
        ]);

        // Jumlah order per halaman
        $perPage = 2;

        // Hitung total halaman
        $totalPages = ceil($totalOrders / $perPage);

        // Ambil halaman saat ini dari query string
        $currentPage = $this->request->getQuery('page', 'int', 1);

        // Hitung offset
        $offset = ($currentPage - 1) * $perPage;

        // Ambil data order dengan pagination
        $orders = Orders::find([
            'conditions' => 'customer_email = :customer_email:',
            'bind' => ['customer_email' => $customer_email],
            'limit' => $perPage,
            'offset' => $offset,
        ]);

        // Inisialisasi array untuk menyimpan data order
        $orderData = [];

        foreach ($orders as $order) {
            // Ambil order detail untuk setiap order
            $orderDetail = Order_details::findFirst([
                'conditions' => 'order_id = :order_id:',
                'bind' => ['order_id' => $order->id],
            ]);

            if ($orderDetail) {
                // Ambil product detail
                $pr = Products::findFirst([
                    'conditions' => 'id = :id:',
                    'bind' => ['id' => $orderDetail->product],
                ]);

                // Ambil provider 
                $provider = Providers::findFirst([
                    'conditions' => 'id = :id:',
                    'bind' => ['id' => $orderDetail->provider],
                ]);

                $provider_name = $provider->name;

                if ($pr) {
                    $product_id = $pr->id;
                    $product_name = $pr->name;
                    $product_url = $pr->slug;
                    $product_code = $pr->sku;

                    // Ambil gambar produk
                    $q = "SELECT f.name FROM Upload_file f 
                        LEFT JOIN Upload_file_morph uf ON uf.upload_file_id = f.id AND uf.related_type = 'products' 
                        WHERE uf.related_id = '".$product_id."' LIMIT 0,1";
                    $pix = $this->modelsManager->executeQuery($q);
                    $product_pix = $pix[0]['name'];

                    // Simpan data order ke dalam array
                    $orderData[] = [
                        'order_placed' => $order->created_at,
                        'activity_date' => $orderDetail->order_date,
                        'sub_total' => (float)$orderDetail->subtotal_price,
                        'rate' => $orderDetail->rate_name,
                        'rateopt' => $orderDetail->rate_opt_name,
                        'module' => $orderDetail->module,
                        'days' => $orderDetail->order_days,
                        'qty' => (float)$orderDetail->quantity,
                        'order_code' => $order->code,
                        'order_status' => $order->status,
                        'product_image' => $product_pix,
                        'product_id' => $product_id,
                        'product_name' => $product_name,
                        'product_url' => $product_url,
                        'provider_name' => $provider_name,
                    ];
                }
            }
        }

        // Kirim data ke view
        $this->view->setVar('orders', $orderData);
        $this->view->setVar('totalPages', $totalPages);
        $this->view->setVar('currentPage', $currentPage);
        // orders section end


        $this->view->setVar('images', $images);
        $this->view->setVar('customer', $customer);

        $this->view->pick('account/review');
    }
    
    public function wishlistAction(){
        $headerCollection = $this->assets->collection('header');
        $headerCollection->addCss('css/orders.css');
        $headerCollection->addCss('css/navbar.css');

        $footerCollection = $this->assets->collection('footer');
        $footerCollection->addJs('https://cdn.jsdelivr.net/npm/sweetalert2@11');
		$footerCollection->addJs('js/orders.js');

        // profile section start
        $customer_id = $this->session->get('trop_auth')['customer_id'];

        $customer = Customers::findFirst([
            'conditions' => 'id = :id:',
            'bind' => ['id' => $customer_id],
        ]);

        $imagesQuery = "SELECT f.name as picture FROM Upload_file_morph uf 
                        LEFT JOIN Upload_file f ON uf.upload_file_id = f.id 
                        WHERE uf.related_id = ".$customer_id."
                        AND uf.related_type = 'customers' LIMIT 1"; 
        $images = $this->modelsManager->executeQuery($imagesQuery);
        // profile section end


        // orders section start
        // Ambil email customer dari session
        $customer_email = $this->session->get('trop_auth')['customer_email'];

        // Hitung total order
        $totalOrders = Orders::count([
            'conditions' => 'customer_email = :customer_email:',
            'bind' => ['customer_email' => $customer_email],
        ]);

        // Jumlah order per halaman
        $perPage = 2;

        // Hitung total halaman
        $totalPages = ceil($totalOrders / $perPage);

        // Ambil halaman saat ini dari query string
        $currentPage = $this->request->getQuery('page', 'int', 1);

        // Hitung offset
        $offset = ($currentPage - 1) * $perPage;

        // Ambil data order dengan pagination
        $orders = Orders::find([
            'conditions' => 'customer_email = :customer_email:',
            'bind' => ['customer_email' => $customer_email],
            'limit' => $perPage,
            'offset' => $offset,
        ]);

        // Inisialisasi array untuk menyimpan data order
        $orderData = [];

        foreach ($orders as $order) {
            // Ambil order detail untuk setiap order
            $orderDetail = Order_details::findFirst([
                'conditions' => 'order_id = :order_id:',
                'bind' => ['order_id' => $order->id],
            ]);

            if ($orderDetail) {
                // Ambil product detail
                $pr = Products::findFirst([
                    'conditions' => 'id = :id:',
                    'bind' => ['id' => $orderDetail->product],
                ]);

                // Ambil provider 
                $provider = Providers::findFirst([
                    'conditions' => 'id = :id:',
                    'bind' => ['id' => $orderDetail->provider],
                ]);

                $provider_name = $provider->name;

                if ($pr) {
                    $product_id = $pr->id;
                    $product_name = $pr->name;
                    $product_url = $pr->slug;
                    $product_code = $pr->sku;

                    // Ambil gambar produk
                    $q = "SELECT f.name FROM Upload_file f 
                        LEFT JOIN Upload_file_morph uf ON uf.upload_file_id = f.id AND uf.related_type = 'products' 
                        WHERE uf.related_id = '".$product_id."' LIMIT 0,1";
                    $pix = $this->modelsManager->executeQuery($q);
                    $product_pix = $pix[0]['name'];

                    // Simpan data order ke dalam array
                    $orderData[] = [
                        'order_placed' => $order->created_at,
                        'activity_date' => $orderDetail->order_date,
                        'sub_total' => (float)$orderDetail->subtotal_price,
                        'rate' => $orderDetail->rate_name,
                        'rateopt' => $orderDetail->rate_opt_name,
                        'module' => $orderDetail->module,
                        'days' => $orderDetail->order_days,
                        'qty' => (float)$orderDetail->quantity,
                        'order_code' => $order->code,
                        'order_status' => $order->status,
                        'product_image' => $product_pix,
                        'product_id' => $product_id,
                        'product_name' => $product_name,
                        'product_url' => $product_url,
                        'provider_name' => $provider_name,
                    ];
                }
            }
        }

        // Kirim data ke view
        $this->view->setVar('orders', $orderData);
        $this->view->setVar('totalPages', $totalPages);
        $this->view->setVar('currentPage', $currentPage);
        // orders section end


        $this->view->setVar('images', $images);
        $this->view->setVar('customer', $customer);

        $this->view->pick('account/wishlist');
    }

    public function logoutAction()
{
    $footerCollection = $this->assets->collection('footer');
    $footerCollection->addJs('https://cdn.jsdelivr.net/npm/sweetalert2@11');

    // Hapus session akun login
    $this->session->remove('trop_auth');  // Menghapus data login

    // Cart masih tetap ada selama session tidak dihancurkan
    // Anda bisa memutuskan untuk menyimpan cart atau membiarkannya
    return $this->response->redirect('account/login');
}

    public function editprofileAction(){
        extract($_POST);
        $cust_id = $this->session->get('trop_auth')['customer_id'];

        $customer = Customers::findFirst([
            'conditions' => 'id = :id:',
            'bind' => ['id' => $cust_id],
        ]);

        $name = $customer_name;
        $email = $customer_email;

        // update customers
        $customer->name = $name;
        $customer->email = $email;
        $customer->save();

        $auth = $this->session->get('trop_auth');
        $auth['customer_name'] = $name;
        $this->session->set('trop_auth', $auth);


    }

    public function changepasswordAction(){
        extract($_POST);
        $cust_id = $this->session->get('trop_auth')['customer_id'];

        $customer = Customers::findFirst([
            'conditions' => 'id = :id:',
            'bind' => ['id' => $cust_id],
        ]);

        $password = password_hash($new_password, PASSWORD_DEFAULT);

        // update customers
        $customer->password = $password;
        $customer->save();


    }

    private function _registerSession($customer,$picture)
    {
        $this->session->set('trop_auth', [
            'customer_id' => $customer->id,
            'customer_hash_id' => $customer->hash_id,
            'customer_email' => $customer->email,
            'customer_name' => $customer->name,
            'customer_country' => $customer->country,
            'customer_picture' => $picture
        ]);
    }

    public function ceksessionAction(){
        $this->view->disable();

        $loggedIn = $this->session->has('trop_auth'); 
        return $this->response->setJsonContent(['loggedIn' => $loggedIn]);
    }

    public function cancelAction(){
        extract($_POST);

        // cek reason harus < 500
        if (strlen($reason) > 500) {
            return $this->response->setJsonContent([
                'status' => 'error',
                'message' => 'Reason must not exceed 500 characters.'
            ]);
        }

        // Cari order berdasarkan code
        $order = Orders::findFirst([
            'conditions' => 'code = :code:',
            'bind' => ['code' => $code]
        ]);

        
        if (!$order) {
            return $this->response->setJsonContent([
                'status' => 'error',
                'message' => 'Order not found.'
            ]);
        }

        // cek apakah order code milik customernya
        if ($order->customer_email !== $this->session->get('trop_auth')['customer_email']) {
            return $this->response->setJsonContent([
                'status' => 'error',
                'message' => 'Unauthorized request.'
            ]);
        }

        // Cari detail order berdasarkan ID dan order 
        $orderDetail = Order_details::findFirst([
            'conditions' => 'id = :id: AND order_id = :order_id:',
            'bind' => [
                'id' => $order_detail_id,
                'order_id' => $order->id
            ]
        ]);

        if (!$orderDetail) {
            return $this->response->setJsonContent([
                'status' => 'error',
                'message' => 'Order detail not found or does not belong to this order.'
            ]);
        }

        // Cek apakah activity_date - 24 jam masih valid
        $activityDate = new \DateTime($orderDetail->order_date);
        $cutoffTime = (clone $activityDate)->modify('-24 hours');
        $now = new \DateTime();

        if ($now >= $cutoffTime) {
            return $this->response->setJsonContent([
                'status' => 'error',
                'message' => 'This order can no longer be canceled.'
            ]);
        }

        if ($orderDetail->detail_status === 'cancelled') {
            return $this->response->setJsonContent([
                'status' => 'error',
                'message' => 'This order detail has already been canceled.'
            ]);
        }

        // Update detail_status dan reason
        $orderDetail->detail_status = 'cancelled';
        $orderDetail->reason = $reason;

        if (!$orderDetail->save()) {
            return $this->response->setJsonContent([
                'status' => 'error',
                'message' => 'Failed to cancel order detail.'
            ]);
        }

        // Cek apakah semua order_details sudah di cancel
        $activeDetails = Order_details::count([
            'conditions' => 'order_id = :order_id: AND detail_status != :cancelled:',
            'bind' => [
                'order_id' => $order->id,
                'cancelled' => 'cancelled'
            ]
        ]);

        // Kalau tidak ada yang aktif, ubah status order jadi cancelled
        if ($activeDetails === 0) {
            $order->status = 'cancelled';
            if (!$order->save()) {
                return $this->response->setJsonContent([
                    'status' => 'error',
                    'message' => 'Order status update failed.'
                ]);
            }
        }

        require '../vendor/autoload.php';

        $orderCode = $order->code;
        $custPhone = $order->customer_phone ?? '-';
        $custName = $order->customer_name;
        $email = $order->customer_email;

        $contries = Countries::findFirst([
            'conditions' => 'iso2 = :iso2:',
            'bind' => ['iso2' => $order->customer_country],
        ]);
        $custCountry = $contries ? $contries->short_name : '-';

        $currency = $this->session->get('currency')['converted'] ?? 'IDR';

        $CancelDetail = [[
            'id' => $orderDetail->id,
            'product_name' => $orderDetail->product_name,
            'module' => $orderDetail->module,
            'product_qty' => $orderDetail->quantity,
            'product_price' => $orderDetail->product_price,
            'total' => $orderDetail->product_price * $orderDetail->quantity,
            'selected_currency' => $currency,
            'orderCode' => $orderCode,
            'phone' => $custPhone,
            'country' => $custCountry,
            'name' => $custName,
            'email' => $email,
            'tanggal' => $orderDetail->order_date,
            'timeselection' => $orderDetail->order_time ?? null,
            'checkin' => $orderDetail->checkin ?? null,
            'checkout' => $orderDetail->checkout ?? null,
            'days' => $orderDetail->order_days ?? null,
            'status' => 'cancelled',
            'reason' => $reason
        ]];

        $mailService = $this->di->get('mail');
        $mailService->cancelOrderAction($CancelDetail);

        return $this->response->setJsonContent([
            'status' => 'success',
            'message' => 'Order detail has been cancelled successfully.'
        ]);

    }

    public function savereviewAction()
{
    $this->view->disable();

    if (!$this->request->isPost()) {
        return $this->response->setJsonContent(['status' => 'error', 'message' => 'Invalid request.']);
    }

    $productId = $this->request->getPost('product_id', 'int');
    $reviewName = $this->request->getPost('review_name', 'string');
    $reviewCountry = $this->request->getPost('review_country', 'string');
    $reviewStar = $this->request->getPost('review_star', 'int');
    $reviewComment = $this->request->getPost('review_comment', 'string');
    $orderDetailId = $this->request->getPost('orderDetail', 'int');

    $auth = $this->session->get('trop_auth');
    $createdBy = isset($auth['email']) ? $auth['email'] : 'system';

    if (!$orderDetailId) {
        return $this->response->setJsonContent([
            'status' => 'error',
            'message' => 'Missing order detail ID.'
        ]);
    }

    $existing = Product_reviews::findFirst([
        'conditions' => 'order_detail_id = :id:',
        'bind' => ['id' => $orderDetailId]
    ]);
    if ($existing) {
        return $this->response->setJsonContent([
            'status' => 'error',
            'message' => 'You have already submitted a review for this order.'
        ]);
    }

    $orderDetail = Order_details::findFirstById($orderDetailId);
    if (!$orderDetail) {
        return $this->response->setJsonContent([
            'status' => 'error',
            'message' => 'Order detail not found.'
        ]);
    }

    $orderDetail->detail_status = 'reviewed';
    if (!$orderDetail->save()) {
            return $this->response->setJsonContent([
                'status' => 'error',
                'message' => 'Failed to cancel order detail.'
            ]);
        }

        // Cari order berdasarkan code
        $order = Orders::findFirst([
            'conditions' => 'id = :id:',
            'bind' => ['id' => $orderDetail->order_id]
        ]);

        // Cek apakah semua order_details sudah di reviewed
        $activeDetails = Order_details::count([
            'conditions' => 'order_id = :order_id: AND detail_status != :status:',
            'bind' => [
                'order_id' => $order->id,
                'status' => 'reviewed'
            ]
        ]);

        // Kalau tidak ada yang aktif, ubah status order jadi reviewed
        if ($activeDetails === 0) {
            $order->status = 'reviewed';
            if (!$order->save()) {
                return $this->response->setJsonContent([
                    'status' => 'error',
                    'message' => 'Order status update failed.'
                ]);
            }
        }

    $review = new Product_reviews();
    $review->product_id = $productId;
    $review->review_name = $reviewName;
    $review->review_country = $reviewCountry;
    $review->review_star = $reviewStar;
    $review->review_comment = $reviewComment;
    $review->order_detail_id = $orderDetailId;
    $review->created_at = date('Y-m-d H:i:s');
    $review->created_by = $createdBy;

    if (!$review->save()) {
        $errors = [];
        foreach ($review->getMessages() as $msg) {
            $errors[] = $msg->getMessage();
        }
        return $this->response->setJsonContent([
            'status' => 'error',
            'message' => implode(', ', $errors)
        ]);
    }

    // === Proses Upload File ===
    if ($this->request->hasFiles(true)) {
        $allowedMimeTypes = ['image/jpeg', 'image/png', 'image/webp', 'video/mp4', 'video/webm'];
        $allowedExtensions = ['jpg', 'jpeg', 'png', 'webp', 'mp4', 'webm'];
        $maxFileSize = 20 * 1024 * 1024; // 20MB

        $files = $this->request->getUploadedFiles(true);
        if (count($files) > 8) {
            return $this->response->setJsonContent([
                'status' => 'error',
                'message' => 'Maksimal 8 file yang dapat diunggah.'
            ]);
        }

        $product = Products::findFirstById($productId);
        $slugProduct = $product ? strtolower(preg_replace('/[^a-z0-9]+/i', '_', $product->name)) : 'product';
        $path = '../../tropadmin/public/uploads/reviews/' . $review->id . '/';
        if (!is_dir($path)) {
            mkdir($path, 0777, true);
        }

        $uploadIndex = 0;
        foreach ($files as $file) {
            if ($file->getError() !== UPLOAD_ERR_OK) {
                continue;
            }

            $mime = $file->getType();
            $ext = strtolower(pathinfo($file->getName(), PATHINFO_EXTENSION));
            $size = $file->getSize();

            if (!in_array($mime, $allowedMimeTypes)) {
                continue;
            }

            if (!in_array($ext, $allowedExtensions)) {
                continue;
            }

            if ($size > $maxFileSize) {
                continue;
            }

            $timestamp = time();
            $customName = "reviews_{$slugProduct}_{$timestamp}_{$uploadIndex}." . $ext;
            $hash = pathinfo($customName, PATHINFO_FILENAME);
            $fullPath = $path . $customName;

            $file->moveTo($fullPath);

            $upload = new Upload_file();
            $upload->name = $customName;
            $upload->hash = $hash;
            $upload->ext = $ext;
            $upload->mime = $mime;
            $upload->size = $size;
            $upload->url = $fullPath;
            $upload->created_at = date('Y-m-d H:i:s');
            $upload->created_by = $createdBy;
            $upload->provider = $createdBy;

            if (!$upload->save()) {
                $errors = [];
                foreach ($upload->getMessages() as $msg) {
                    $errors[] = $msg->getMessage();
                }
                return $this->response->setJsonContent([
                    'status' => 'error',
                    'message' => 'Upload file gagal: ' . implode(', ', $errors)
                ]);
            }

            $morph = new Upload_file_morph();
            $morph->upload_file_id = $upload->id;
            $morph->related_id = $review->id;
            $morph->related_type = 'reviews';
            $morph->field = (substr($mime, 0, 5) === 'video') ? 'videos' : 'images';

            if (!$morph->save()) {
                $errors = [];
                foreach ($morph->getMessages() as $msg) {
                    $errors[] = $msg->getMessage();
                }
                return $this->response->setJsonContent([
                    'status' => 'error',
                    'message' => 'Gagal menyimpan relasi file: ' . implode(', ', $errors)
                ]);
            }

            $uploadIndex++;
        }
    }

    return $this->response->setJsonContent([
        'status' => 'success',
        'message' => 'Review berhasil dikirim.'
    ]);
}

    public function logingoogleAction()
    {
        require '../vendor/autoload.php';

        $previousUrl = $this->request->getHTTPReferer();
        $this->session->set('redirect_after_login', $previousUrl); // simpan ke session

        $client = new Client();
        $client->setClientId($this->config->google->clientId);
        $client->setClientSecret($this->config->google->clientSecret);
        $client->setRedirectUri($this->config->google->redirect_uri);
        $client->addScope('email');
        $client->addScope('profile');

        $authUrl = $client->createAuthUrl();

        return $this->response->redirect($authUrl);
    }

    public function callbackgoogleAction()
{
    require '../vendor/autoload.php';

    $client = new \Google\Client();
    $client->setClientId($this->config->google->clientId);
    $client->setClientSecret($this->config->google->clientSecret);
    $client->setRedirectUri($this->config->google->redirect_uri);

    if ($this->request->get('code')) {
        $token = $client->fetchAccessTokenWithAuthCode($this->request->get('code'));

        if (isset($token['error'])) {
            echo "Token error: " . $token['error_description'];
            return false;
        }

        $client->setAccessToken($token);
        $oauth2 = new \Google\Service\Oauth2($client);
        $userInfo = $oauth2->userinfo->get();

        // Langsung set session tanpa simpan ke database
        $dummyCustomer = (object)[
            'id' => 'google',
            'hash_id' => 'google_' . md5($userInfo->email),
            'email' => $userInfo->email,
            'name' => $userInfo->name,
            'country' => '',
        ];

        $this->_registerSession($dummyCustomer, $userInfo->picture);


        // Ambil URL sebelumnya di session
        $redirectUrl = $this->session->get('redirect_after_login', 'cart');

        // Hapus dari session 
        $this->session->remove('redirect_after_login');

        return $this->response->redirect($redirectUrl);
    }

    echo "Login gagal.";
}

//     public function addwishlistAction()
//     {
//         $this->view->disable();
//         $this->response->setContentType('application/json', 'UTF-8');

//         $customer_session = $this->session->get('trop_auth');
//         if(!$customer_session){
//             return $this->response->setJsonContent([
//                 'success' => false,
//                 'message' => 'Please login first to access this feature.'
//             ]);
//         }

//         $customerId = $this->session->get('trop_auth')['customer_id']; // pastikan session ini aktif

//         $data = json_decode($this->request->getRawBody(), true);
//         $productId = $data['product_id'] ?? null;

//         if (!$customerId || !$productId) {
//             return $this->response->setJsonContent([
//                 'success' => false,
//                 'message' => 'Data tidak valid.'
//             ]);
//         }

//         // Cek jika sudah ada di wishlist
//         $exists = Wishlist::findFirst([
//             'conditions' => 'id_customer = :cid: AND id_product = :pid:',
//             'bind' => [
//                 'cid' => $customerId,
//                 'pid' => $productId
//             ]
//         ]);

//         if ($exists) {
//             return $this->response->setJsonContent([
//                 'success' => false,
//                 'message' => 'Produk sudah ada di wishlist.'
//             ]);
//         }

//         $wishlist = new Wishlist();
//         $wishlist->id_customer = $customerId;
//         $wishlist->id_product = $productId;
//         $wishlist->created_at = date('Y-m-d H:i:s');

//         if ($wishlist->save()) {
//             return $this->response->setJsonContent(['success' => true]);
//         } else {
//             return $this->response->setJsonContent([
//                 'success' => false,
//                 'message' => 'Gagal menyimpan data.'
//             ]);
//         }
//     }

//     public function removewishlistAction()
// {
//     $this->view->disable();
//     $this->response->setContentType('application/json', 'UTF-8');

//     $customerId = $this->session->get('trop_auth')['customer_id'];
//     $data = json_decode($this->request->getRawBody(), true);
//     $productId = $data['product_id'] ?? null;

//     if (!$customerId || !$productId) {
//         return $this->response->setJsonContent([
//             'success' => false,
//             'message' => 'Data tidak valid.'
//         ]);
//     }

//     $wishlist = Wishlist::findFirst([
//         'conditions' => 'id_customer = :cid: AND id_product = :pid:',
//         'bind' => [
//             'cid' => $customerId,
//             'pid' => $productId
//         ]
//     ]);

//     if ($wishlist && $wishlist->delete()) {
//         return $this->response->setJsonContent(['success' => true]);
//     }

//     return $this->response->setJsonContent([
//         'success' => false,
//         'message' => 'Gagal menghapus wishlist.'
//     ]);
// }



}