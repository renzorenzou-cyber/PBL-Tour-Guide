<?php 

class WishlistController extends ControllerBase
{
    public function wishlistAction(){
        $this->assets->collection('header')
        ->addCss('css/orders.css')
        ->addCss('css/navbar.css')
        ->addCss('https://cdn.jsdelivr.net/npm/@fancyapps/ui/dist/fancybox.css')
        ->addCss('https://cdn.jsdelivr.net/npm/swiper/swiper-bundle.min.css');
		

        $this->assets->collection('footer')
        ->addJs('https://cdn.jsdelivr.net/npm/sweetalert2@11')
        ->addJs('https://cdn.jsdelivr.net/npm/swiper/swiper-bundle.min.js')
        ->addJs('https://cdn.jsdelivr.net/npm/@fancyapps/ui/dist/fancybox.umd.js')
        ->addJs('js/wishlist.js'); 
		$user = $this->session->get('trop_auth')['customer_email'];
		$wishlist = Wishlist::findFirst([
			'conditions' => 'customer_email = :email:',
        	'bind' => ['email' => $user],
		]);

		if($user && $wishlist){
			$wishlistPage = $this->dispatcher->getParam('page', 'int', 1);
			$wishlistPerPage = 8;
			$wishlistoffset = ($wishlistPage - 1) * $wishlistPerPage;
			$wishlistProductIds = [];

			$wishlistDetail = Wishlist_detail::find([
				'conditions' => 'id_wishlist = :id:',
				'bind' => ['id' => $wishlist->id],
			]);

			foreach ($wishlistDetail as $item) {
				$wishlistProductIds[] = $item->id_product;
			}

			if (empty($wishlistProductIds)) {
				// Tidak ada produk dalam wishlist
				
				$this->view->setVars([
					'wishlistData' => [],
					'total_pages'  => 0,
					'page'         => 1,
					'picUrl'       => $this->config->vars->picUrl,
				]);

				$this->tag->setTitle('Wishlist');

        		$this->view->pick('page/wishlist');
				return;
			}

			$wishlistProduct = Products::find([
					'conditions' => 'id IN ({ids:array})',
					'bind'       => ['ids' => $wishlistProductIds],
					'limit'      => $wishlistPerPage,
					'offset'     => $wishlistoffset
				]);

				$totalWishlist = Products::count([
					'conditions' => 'id IN ({ids:array})',
					'bind'       => ['ids' => $wishlistProductIds],
				]);
				$wishlistTotalPages = ceil($totalWishlist / $wishlistPerPage);

				$wishlistData = [];

				foreach ($wishlistProduct as $wishlist) {
					$product = Products::findFirstById($wishlist->id);

					// --- Harga termurah ---
					$minPriceQuery = "
						SELECT MIN(ra.publish_price) AS min_price
						FROM Rates r
						JOIN Rate_options ro ON ro.id_rate = r.id
						JOIN Rate_availability ra ON ra.id_rate_opt = ro.id
						WHERE r.product = :product_id: AND ra.publish_price > 0
					";
					$minPriceResult = $this->modelsManager->executeQuery($minPriceQuery, [
						'product_id' => $wishlist->id
					]);
					$minPublishPrice = $minPriceResult[0]['min_price'] ?? 0;

					$discounted_price = $minPublishPrice;
					$rate_option_price = $minPublishPrice;

					// --- Cek Hotdeal ---
					$rateOptionQuery = "
						SELECT ro.id
						FROM Rates r
						JOIN Rate_options ro ON ro.id_rate = r.id
						JOIN Rate_availability ra ON ra.id_rate_opt = ro.id
						WHERE r.product = :product_id: AND ra.publish_price = :min_price:
						LIMIT 1
					";
					$rateOpt = $this->modelsManager->executeQuery($rateOptionQuery, [
						'product_id' => $wishlist->id,
						'min_price'  => $minPublishPrice
					])->getFirst();

					if ($rateOpt) {
						$hotdealQuery = "
							SELECT hotdeal_type, hotdeal_value, promo_status
							FROM Hotdeals
							WHERE FIND_IN_SET(:rate_option_id:, rates) > 0
						";
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

					$rateData = [
						'rate_option_price' => $rate_option_price,
						'discounted_price'  => ($discounted_price < $minPublishPrice) ? max($discounted_price, 0) : 0,
						'min_publish_price' => $minPublishPrice,
					];

					// --- Ambil review + fallback ---
					$wishlistreviewer = Product_reviews::count([
						'conditions' => 'product_id = :id: AND parent_id = 0',
						'bind'       => ['id' => $wishlist->id],
					]);

					$wishlisttotalStars = 0;
					$wishlisttotalReviews = $wishlistreviewer;
					$wishlistaverageRating = 0;

					if ($wishlisttotalReviews > 0) {
						$qr = "
							SELECT review_star 
							FROM Product_reviews 
							WHERE product_id = :pid: AND parent_id = 0
						";
						$rev = $this->modelsManager->executeQuery($qr, ['pid' => $wishlist->id]);
						foreach ($rev as $r) {
							$wishlisttotalStars += $r->review_star;
						}
						$wishlistaverageRating = round($wishlisttotalStars / $wishlisttotalReviews, 1);
					} else {
						$providerId = $wishlist->provider;
						$providerProducts = Products::find([
							'conditions' => 'provider = :provider_id:',
							'bind'       => ['provider_id' => $providerId],
							'columns'    => 'id'
						]);

						$providerProductIds = [];
						foreach ($providerProducts as $prod) {
							$providerProductIds[] = $prod->id;
						}

						if (!empty($providerProductIds)) {
							$qFallback = "
								SELECT review_star 
								FROM Product_reviews 
								WHERE product_id IN ({ids:array}) AND parent_id = 0
							";
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
							}
						}
					}

					$reviewData = [
						'total_review'   => $wishlisttotalReviews,
						'average_rating' => $wishlistaverageRating,
						'is_provider'    => ($wishlistreviewer == 0)
					];

					// --- Ambil gambar ---
					$pixQuery = "
						SELECT f.name 
						FROM Upload_file f 
						LEFT JOIN Upload_file_morph uf ON uf.upload_file_id = f.id AND uf.related_type = 'products' 
						WHERE uf.related_id = :pid: 
						LIMIT 1
					";
					$pix = $this->modelsManager->executeQuery($pixQuery, ['pid' => $product->id]);
					$product_pix = isset($pix[0]['name']) ? $pix[0]['name'] : '';

					// --- Push data final ---
					$wishlistData[] = [
						'product_image' => $product_pix,
						'product_desc'  => $product->page_title,
						'product_id'    => $product->id,
						'product_name'  => $product->name,
						'product_url'   => $product->slug,
						'product_group' => $product->group_product,
						'provider_name' => $product->Providers->name ?? '',
						'ordered'       => $product->ordered,
						'rate'          => $rateData,
						'review'        => $reviewData
					];
				}

				foreach ($wishlistData as &$w) {
					if ($w['ordered'] >= 1000) {
						$w['ordered_formatted'] = number_format($w['ordered'] / 1000, 1) . 'k';
					} else {
						$w['ordered_formatted'] = $w['ordered'];
					}

					$w['rate_option_price_formatted'] = number_format($w['rate']['rate_option_price'] ?? 0, 0, ',', '.');
					$w['discounted_price_formatted'] = number_format($w['rate']['discounted_price'] ?? 0, 0, ',', '.');
					$w['min_publish_price_formatted'] = number_format($w['rate']['min_publish_price'] ?? 0, 0, ',', '.');
				}
			// echo "<pre>";
			// print_r($wishlistData);
			// echo "</pre>";
			// die('x');


				$this->view->setVars([
        			'wishlistData'     => $wishlistData,
					'total_pages'  => $wishlistTotalPages,
					'page'  => $wishlistPage,
					'picUrl' => $this->config->vars->picUrl,
				]);

		} else {
            if ($this->request->isPost() && $this->request->isAjax()) {
				$body = $this->request->getJsonRawBody(true);
				$wishlistIds = $body['wishlist_ids'] ?? [];
				$wishlistPerPage = 8;
				$wishlistPage = (int) $this->dispatcher->getParam('page', 'int', 1);
				$wishlistOffset = ($wishlistPage - 1) * $wishlistPerPage;

				if (empty($wishlistIds) || !is_array($wishlistIds)) {
					return $this->response->setJsonContent([
						'wishlist' => [],
						'total_pages' => 0
					]);
				}

				// Ambil produk dengan pagination
				$wishlistProduct = Products::find([
					'conditions' => 'id IN ({ids:array})',
					'bind'       => ['ids' => $wishlistIds],
					'limit'      => $wishlistPerPage,
					'offset'     => $wishlistOffset
				]);

				$totalWishlist = Products::count([
					'conditions' => 'id IN ({ids:array})',
					'bind'       => ['ids' => $wishlistIds],
				]);
				$wishlistTotalPages = ceil($totalWishlist / $wishlistPerPage);

				$wishlistData = [];

				foreach ($wishlistProduct as $wishlist) {
					$product = Products::findFirstById($wishlist->id);

					// --- Harga termurah ---
					$minPriceQuery = "
						SELECT MIN(ra.publish_price) AS min_price
						FROM Rates r
						JOIN Rate_options ro ON ro.id_rate = r.id
						JOIN Rate_availability ra ON ra.id_rate_opt = ro.id
						WHERE r.product = :product_id: AND ra.publish_price > 0
					";
					$minPriceResult = $this->modelsManager->executeQuery($minPriceQuery, [
						'product_id' => $wishlist->id
					]);
					$minPublishPrice = $minPriceResult[0]['min_price'] ?? 0;

					$discounted_price = $minPublishPrice;
					$rate_option_price = $minPublishPrice;

					// --- Cek Hotdeal ---
					$rateOptionQuery = "
						SELECT ro.id
						FROM Rates r
						JOIN Rate_options ro ON ro.id_rate = r.id
						JOIN Rate_availability ra ON ra.id_rate_opt = ro.id
						WHERE r.product = :product_id: AND ra.publish_price = :min_price:
						LIMIT 1
					";
					$rateOpt = $this->modelsManager->executeQuery($rateOptionQuery, [
						'product_id' => $wishlist->id,
						'min_price'  => $minPublishPrice
					])->getFirst();

					if ($rateOpt) {
						$hotdealQuery = "
							SELECT hotdeal_type, hotdeal_value, promo_status
							FROM Hotdeals
							WHERE FIND_IN_SET(:rate_option_id:, rates) > 0
						";
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

					$rateData = [
						'rate_option_price' => $rate_option_price,
						'discounted_price'  => ($discounted_price < $minPublishPrice) ? max($discounted_price, 0) : 0,
						'min_publish_price' => $minPublishPrice,
					];

					// --- Ambil review + fallback ---
					$wishlistreviewer = Product_reviews::count([
						'conditions' => 'product_id = :id: AND parent_id = 0',
						'bind'       => ['id' => $wishlist->id],
					]);

					$wishlisttotalStars = 0;
					$wishlisttotalReviews = $wishlistreviewer;
					$wishlistaverageRating = 0;

					if ($wishlisttotalReviews > 0) {
						$qr = "
							SELECT review_star 
							FROM Product_reviews 
							WHERE product_id = :pid: AND parent_id = 0
						";
						$rev = $this->modelsManager->executeQuery($qr, ['pid' => $wishlist->id]);
						foreach ($rev as $r) {
							$wishlisttotalStars += $r->review_star;
						}
						$wishlistaverageRating = round($wishlisttotalStars / $wishlisttotalReviews, 1);
					} else {
						$providerId = $wishlist->provider;
						$providerProducts = Products::find([
							'conditions' => 'provider = :provider_id:',
							'bind'       => ['provider_id' => $providerId],
							'columns'    => 'id'
						]);

						$providerProductIds = [];
						foreach ($providerProducts as $prod) {
							$providerProductIds[] = $prod->id;
						}

						if (!empty($providerProductIds)) {
							$qFallback = "
								SELECT review_star 
								FROM Product_reviews 
								WHERE product_id IN ({ids:array}) AND parent_id = 0
							";
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
							}
						}
					}

					$reviewData = [
						'total_review'   => $wishlisttotalReviews,
						'average_rating' => $wishlistaverageRating,
						'is_provider'    => ($wishlistreviewer == 0)
					];

					// --- Ambil gambar ---
					$pixQuery = "
						SELECT f.name 
						FROM Upload_file f 
						LEFT JOIN Upload_file_morph uf ON uf.upload_file_id = f.id AND uf.related_type = 'products' 
						WHERE uf.related_id = :pid: 
						LIMIT 1
					";
					$pix = $this->modelsManager->executeQuery($pixQuery, ['pid' => $product->id]);
					$product_pix = isset($pix[0]['name']) ? $pix[0]['name'] : '';

					// --- Push data final ---
					$wishlistData[] = [
						'product_image' => $product_pix,
						'product_desc'  => $product->page_title,
						'product_id'    => $product->id,
						'product_name'  => $product->name,
						'product_url'   => $product->slug,
						'product_group' => $product->group_product,
						'provider_name' => $product->Providers->name ?? '',
						'ordered'       => $product->ordered,
						'rate'          => $rateData,
						'review'        => $reviewData
					];
				}

				return $this->response->setJsonContent([
					'wishlist'     => $wishlistData,
					'total_pages'  => $wishlistTotalPages
				]);
			}
		}

        $this->tag->setTitle('Wishlist');

        $this->view->pick('page/wishlist');

	}

    public function savewishlistAction()
	{
		$this->view->disable();

		extract($_POST);

		$productId = $wishlist ?? null;
		if (!$productId) {
			return $this->response->setJsonContent([
				'status' => 'error',
				'message' => 'No product data received.',
			]);
		}

		$auth = $this->session->get('trop_auth');
		if (!$auth || empty($auth['customer_email'])) {
			return $this->response->setJsonContent([
				'status' => 'error',
				'message' => 'User not logged in.',
			]);
		}

		$email = $auth['customer_email'];

		// Cek wishlist utama berdasarkan email
		$cekWishlist = Wishlist::findFirst([
			'conditions' => 'customer_email = :email:',
			'bind' => ['email' => $email],
		]);

		if (!$cekWishlist) {
			// Buat wishlist baru kalau belum ada
			$wish = new Wishlist();
			$wish->customer_email = $email;
			$wish->save();
			$wishlistId = $wish->id;
		} else {
			$wishlistId = $cekWishlist->id;
		}

		foreach ($productId as $idp) {
			// Cek apakah produk sudah ada di wishlist_detail user ini
			$cekDetail = Wishlist_detail::findFirst([
				'conditions' => 'id_wishlist = :wid: AND id_product = :pid:',
				'bind' => [
					'wid' => $wishlistId,
					'pid' => $idp,
				],
			]);

			if ($cekDetail) {
				// hapus
				$cekDetail->delete();
			} else {
				// tambahkan
				$wish_detail = new Wishlist_detail();
				$wish_detail->id_wishlist = $wishlistId;
				$wish_detail->id_product = $idp;
				$wish_detail->save();
			}
		}
	}

    public function getwishlistAction(){
		$userEmail = $this->session->get('trop_auth')['customer_email'];

        $wishlist = Wishlist::findFirst([
            'conditions' => 'customer_email = :email:',
            'bind'       => ['email' => $userEmail],
        ]);

		$wishlistDetail = Wishlist_detail::find([
            'conditions' => 'id_wishlist = :id:',
            'bind'       => ['id' => $wishlist->id],
        ]);

        $dataWishlist = [];
        foreach ($wishlistDetail as $item) {
            $dataWishlist[] = [
                'product_id' => $item->id_product
            ];
        }

        return $this->response->setJsonContent($dataWishlist);
	}

}