<?php

use Phalcon\Mvc\Controller;

class ControllerBase extends Controller
{
	public function initialize(){
		// $abc = $this->session->get('trop_auth');
		// print_r($abc);die();
        ini_set('display_errors', '0');
		ini_set('display_startup_errors', '0');
		error_reporting(E_ALL & ~E_DEPRECATED & ~E_STRICT);
        $this->tag->appendTitle(' | Tropialis');
		//generate global header
		$headerCollection = $this->assets->collection('header');
		$headerCollection->addCss('https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700');
		$headerCollection->addCss('assets/vendor/bootstrap/bootstrap.min.css');
		$headerCollection->addCss('assets/vendor/icon-awesome/css/font-awesome.min.css');
		$headerCollection->addCss('assets/vendor/icon-line/css/simple-line-icons.css');
		$headerCollection->addCss('assets/vendor/icon-etlinefont/style.css');
		$headerCollection->addCss('assets/vendor/icon-line-pro/style.css');
		$headerCollection->addCss('assets/vendor/icon-hs/style.css');
		$headerCollection->addCss('assets/vendor/animate.css');
		$headerCollection->addCss('assets/vendor/dzsparallaxer/dzsparallaxer.css');
		$headerCollection->addCss('assets/vendor/dzsparallaxer/dzsscroller/scroller.css');
		$headerCollection->addCss('assets/vendor/dzsparallaxer/advancedscroller/plugin.css');
		$headerCollection->addCss('assets/vendor/slick-carousel/slick/slick.css');
		$headerCollection->addCss('assets/vendor/hamburgers/hamburgers.min.css');
		$headerCollection->addCss('assets/vendor/hs-megamenu/src/hs.megamenu.css');
		$headerCollection->addCss('assets/vendor/hamburgers/hamburgers.min.css');
		$headerCollection->addCss('assets/css/styles.e-commerce.css');
		$headerCollection->addCss('assets/css/holdOn.css');
		//CSS UNIFY
		$headerCollection->addCss('assets/css/unify-core.css');
		$headerCollection->addCss('assets/css/unify-components.css');
		$headerCollection->addCss('assets/css/unify-globals.css');
		$headerCollection->addCss('css/custom.css');

		$footerCollection = $this->assets->collection('footer');

		//GLOBAL
		$footerCollection->addJs('assets/vendor/jquery/jquery.min.js');
		$footerCollection->addJs('assets/vendor/jquery-migrate/jquery-migrate.min.js');
		$footerCollection->addJs('assets/vendor/popper.min.js');
		$footerCollection->addJs('assets/vendor/bootstrap/bootstrap.min.js');
		//PLUGINS
		$footerCollection->addJs('assets/vendor/hs-megamenu/src/hs.megamenu.js');
		$footerCollection->addJs('assets/vendor/dzsparallaxer/dzsparallaxer.js');
		$footerCollection->addJs('assets/vendor/dzsparallaxer/dzsscroller/scroller.js');
		$footerCollection->addJs('assets/vendor/dzsparallaxer/advancedscroller/plugin.js');
		$footerCollection->addJs('assets/vendor/appear.js');
		$footerCollection->addJs('assets/vendor/slick-carousel/slick/slick.js');
		$footerCollection->addJs('https://cdn.jsdelivr.net/npm/sweetalert2@11');
		//JS UNIFY
		$footerCollection->addJs('assets/js/hs.core.js');
		$footerCollection->addJs('assets/js/components/hs.header.js');
		$footerCollection->addJs('assets/js/helpers/hs.hamburgers.js');
		$footerCollection->addJs('assets/js/components/hs.dropdown.js');
		$footerCollection->addJs('assets/js/components/hs.tabs.js');
		$footerCollection->addJs('assets/js/components/hs.progress-bar.js');
		$footerCollection->addJs('assets/js/components/hs.rating.js');
		$footerCollection->addJs('assets/js/components/hs.counter.js');
		$footerCollection->addJs('assets/js/components/hs.carousel.js');
		$footerCollection->addJs('assets/js/components/hs.go-to.js');
		$footerCollection->addJs('assets/js/components/hs.scrollbar.js');
		$footerCollection->addJs('assets/js/holdOn.js');
		
		//CUSTOM
		$footerCollection->addJs('js/global.js');
		$footerCollection->addJs('js/general.js');
		$footerCollection->addJs('js/custom.js');

		$this->view->setVar('pixurl','http://localhost/tropadmin/public/uploads');
		// $this->view->setVar('pixurl','https://media.tropialis.com/public/uploads');
		$this->view->setVar('lifestyle','http://localhost/tropialis/lifestyle');
		// $this->view->setVar('lifestyle','https://lifestyle.tropialis.com');
		
		//load navbar
		$this->navbar();
		$this->subnavbar();
		$this->bestpackage();
		$this->latestarticles();
		$this->quotes();
		$this->currencies();
		$this->basecurrency();
		$this->highlight();
		$this->areas();
	}

	public function basecurrency(){
		if($this->session->has('currency') != 1){
			$this->session->set('currency', [
				'base' => 'IDR',
				'converted' => 'IDR',
				'index' => 1
			]);
		}
	}

	public function areas(){
		if($this->session->has('areas') != 1){
			$this->session->set('areas', [
				'default' => 'bali',
				'selected' => 'bali'
			]);
		}
	}

	public function currencies(){
		//get list active currency
		$c = Currencies::find([
			'conditions' => 'currency_status = :currency_status:',
			'bind' => ['currency_status' => 1]
		]); 
		$this->view->setVar('currencies',$c);
	}

	public function checkrate(){
		//check existing rate
		$date = date("Y-m-d");
		$cek = Currencies_daily_rate::findFirst([
			'conditions' => 'date = :date:',
            'bind' => ['date' => $date]
		]);
		if($cek == false){
			//insert rate
			
		}
	}

	public function quotes(){
		$qts = "SELECT q.id, q.person, q.job, q.year, q.quote, f.name as photo FROM Quotes q LEFT JOIN Upload_file_morph um ON (q.id = um.related_id AND um.related_type = 'quotes') LEFT JOIN Upload_file f ON f.id = um.upload_file_id ORDER BY RAND() LIMIT 0,1";
		$quotes = $this->modelsManager->executeQuery($qts);
		$this->view->setVar('quotes',$quotes[0]);
	}

	public function navbar(){
		$q = "SELECT id, group_product_parent, group_product, group_product_url, group_product_sort, group_product_status, is_child FROM Group_products WHERE group_product_status = 1 AND group_product_parent = 0 ORDER BY group_product_sort ASC";
        $cek = $this->modelsManager->executeQuery($q);
        $this->view->setVar('menu',$cek);
	}

	public function subnavbar(){
		$q = "SELECT id, group_product_parent, group_product, group_product_url, group_product_sort, group_product_status, is_child FROM Group_products WHERE group_product_status = 1 AND group_product_parent <> 0 ORDER BY group_product_sort ASC";
        $cek = $this->modelsManager->executeQuery($q);
        $this->view->setVar('submenu',$cek);	
	}

	public function bestpackage(){
		$headerCollection = $this->assets->collection('header');
        $headerCollection->addCss('https://cdn.jsdelivr.net/npm/swiper/swiper-bundle.min.css');
    	$headerCollection->addCss('https://cdn.jsdelivr.net/npm/@fancyapps/ui@5.0/dist/fancybox/fancybox.css');
        $headerCollection->addCss('https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css');
        $headerCollection->addCss('css/custom.css');

        // Footer Assets
		$footerCollection = $this->assets->collection('footer');
		$footerCollection->addJs('https://cdn.jsdelivr.net/npm/swiper/swiper-bundle.min.js');
    	$footerCollection->addJs('https://cdn.jsdelivr.net/npm/@fancyapps/ui@5.0/dist/fancybox/fancybox.umd.js'); 
		$footerCollection->addJs('js/custom.js');

		$limit = 8;

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

				// Cari semua sub-area dari area tersebut
				$subAreas = Areas::find([
					'conditions' => 'area_parent = :parent:',
					'bind' => ['parent' => $parentId]
				]);

				$areaIds = [$parentId];
				foreach ($subAreas as $sub) {
					$areaIds[] = $sub->id_area;
				}

				// Cari semua produk yang terhubung dengan area tersebut
				$areaProducts = Areas_products::find([
					'conditions' => 'id_area IN ({ids:array})',
					'bind' => ['ids' => $areaIds]
				]);

				$tempProductIds = [];
				foreach ($areaProducts as $ap) {
					$tempProductIds[] = $ap->id_product;
				}

				// Filter produk yang aktif (product_status = 1)
				if (!empty($tempProductIds)) {
					$builder = $this->modelsManager->createBuilder()
						->from('Products')
						->inWhere('id', $tempProductIds)
						->andWhere('product_status = 1')
						->andWhere("EXISTS (
							SELECT 1 FROM Rates r
							JOIN Rate_options ro ON ro.id_rate = r.id
							JOIN Rate_availability ra ON ra.id_rate_opt = ro.id
							WHERE r.product = Products.id AND ra.publish_price > 0
						)");

					$activeProducts = $builder->getQuery()->execute();

					foreach ($activeProducts as $product) {
						$productAreaIds[] = $product->id;
					}
				}
			}
		}

		if (!empty($productAreaIds)) {
		// ambil random dari product-area terfilter
		shuffle($productAreaIds); // acak dulu
		$productIds = array_slice($productAreaIds, 0, $limit); // ambil sesuai limit
		$idStr = implode(',', $productIds);

		$q = "SELECT p.id, p.name, p.slug, p.description, p.page_title, p.group_product, p.provider, product_status, p.ordered,
				(SELECT f.name FROM Upload_file_morph uf 
				JOIN Upload_file f ON f.id = uf.upload_file_id 
				WHERE uf.related_type = 'products' AND uf.related_id = p.id 
				ORDER BY f.id LIMIT 1) as picture,
				(SELECT SUM(r.review_star)/COUNT(r.id) 
				FROM Product_reviews r WHERE r.product_id = p.id) as review
			FROM Products p
			WHERE product_status = 1
			AND p.id IN ({$idStr})
			AND EXISTS (
            SELECT 1 FROM Rates r2
            JOIN Rate_options ro2 ON ro2.id_rate = r2.id
            JOIN Rate_availability ra2 ON ra2.id_rate_opt = ro2.id
            WHERE r2.product = p.id AND ra2.publish_price > 0
            )
		";
		$products = $this->modelsManager->executeQuery($q);
		$this->view->setVar('pack', $products);
		} else {
			$products = [];
		}

		// Get rate options & prices for those products
		$productIds = [];
		foreach ($products as $p) {
			$productIds[] = $p->id;
		}

		$rates = [];
		$reviewStats = [];
		if (!empty($productIds)) {
			$idStr = implode(',', $productIds);
			foreach ($products as $val) {
				// publish_price terendah 
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
				$rate_option_price = $minPublishPrice;

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

				$rates[$val->id] = [
					'rate_option_price' => $rate_option_price,
					'discounted_price' => ($discounted_price < $minPublishPrice) ? max($discounted_price, 0) : 0,
					'min_publish_price' => $minPublishPrice,
				];
			}


			foreach($products as $val){
				$qr = "SELECT rev.id, rev.parent_id, rev.product_id, rev.review_star, rev.review_comment, rev.review_name, rev.review_country, rev.created_at FROM Product_reviews rev WHERE product_id = '".$val['id']."' AND rev.parent_id = 0 ORDER BY rev.created_at DESC";
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
            'is_provider'    => ($reviewer == 0) ? true : false
        ];
			}


		}

		$this->view->setVar('hotdeals', $rates);
		$this->view->setVar('reviewStats', $reviewStats);

		// Images fallback (opsional jika ingin ambil banyak gambar)
		$imagesQuery = "
			SELECT p.id, f.name as picture 
			FROM Products p 
			JOIN Upload_file_morph uf ON uf.related_id = p.id 
			JOIN Upload_file f ON f.id = uf.upload_file_id 
			WHERE uf.related_type = 'products' AND uf.field = 'images'
			ORDER BY f.id
		";
		$images = $this->modelsManager->executeQuery($imagesQuery);
		$this->view->setVar('images', $images);

		$wishlistProductIds = [];

		if ($this->session->has('trop_auth')) {
			$customerEmail = $this->session->get('trop_auth')['customer_email'];

			$wishlistId = Wishlist::findFirst([
				'conditions' => 'customer_email = :email:',
				'bind' => ['email' => $customerEmail],
			]);

			if ($wishlistId) {
				$wishlistItems = Wishlist_detail::find([
					'conditions' => 'id_wishlist = :id:',
					'bind'       => ['id' => $wishlistId->id],
				]);

				$wishlistProductIds = [];
				foreach ($wishlistItems as $item) {
					$wishlistProductIds[] = $item->id_product;
				}
			} else {
				$wishlistProductIds = [];
			}
		}

		$this->view->setVar('wishlistProductIds', $wishlistProductIds);


	}

	public function latestarticles(){
		$q = "SELECT a.id, a.article_title, a.article_slug, a.article_text, a.article_status, a.article_category, a.publish_date, a.page_title, a.meta_description, a.visit_count, (SELECT f.name FROM Upload_file_morph uf LEFT JOIN Upload_file f ON f.id = uf.upload_file_id WHERE uf.related_type = 'articles' AND uf.related_id = a.id LIMIT 0,1) as picture, a.publish_by, u.name FROM Articles a LEFT JOIN Userspermissions_user u ON a.publish_by = u.id WHERE a.article_status = 1 ORDER BY a.publish_date DESC LIMIT 0,9";
		$row = $this->modelsManager->executeQuery($q);

		// Kelompokkan tiap 3 artikel
		$grouped = [];
		$temp = [];
		$i = 0;
		foreach ($row as $article) {
			$temp[] = $article;
			$i++;
			if ($i % 3 == 0) {
			$grouped[] = $temp;
			$temp = [];
			}
		}
		if (!empty($temp)) {
			$grouped[] = $temp; 
		}

		$this->view->setVar('articleGroups', $grouped);
		$this->view->setVar('articles',$row);
	}

	public function generate_random_sku($len=0){
        $result = "TROP";
        $chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";//tanpa huruf O besar dan I besar
        $charArray = str_split($chars);
        for($i = 0; $i < $len; $i++){
            $randItem = array_rand($charArray);
            $result .= "".$charArray[$randItem];
        }
        return $result;
		    // Add initial random numbers (0-3) before first letter
		// $initialNumbers = rand(0, 3);
		// for ($i = 0; $i < $initialNumbers; $i++) {
		// 	$result[$currentPosition++] = $numberArray[array_rand($numberArray)];
		// }
		
		// // Place letters with 1-3 random numbers between them
		// foreach ($requiredLetters as $letter) {
		// 	$result[$currentPosition++] = $letter;
			
		// 	// Add random numbers after each letter (except last one)
		// 	if ($currentPosition < 18 && $letter != 'S') {
		// 		$gapSize = rand(1, 3);
		// 		for ($i = 0; $i < $gapSize && $currentPosition < 18; $i++) {
		// 			$result[$currentPosition++] = $numberArray[array_rand($numberArray)];
		// 		}
		// 	}
		// }
		
		// // Fill remaining positions with random numbers if needed
		// while ($currentPosition < 18) {
		// 	$result[$currentPosition++] = $numberArray[array_rand($numberArray)];
		// }
		
		// // Ensure exactly 18 characters
		// $result = array_slice($result, 0, 18);
		// return implode('', $result);
    }

	public function generate_random_char($len){
        $result = "";
        $chars = "ABCDEFGHJKLMNPQRSTUVWXYZ0123456789";//tanpa huruf O besar dan I besar
        $charArray = str_split($chars);
        for($i = 0; $i < $len; $i++){
            $randItem = array_rand($charArray);
            $result .= "".$charArray[$randItem];
        }
        return $result;
    }

	function formatNumberShort($number) {
		if ($number >= 1000) {
			return number_format($number / 1000, 1) . 'k';
		}
		return $number;
	}


	public function formatCurrency($amount, $currency) {
		$formats = [
			'AUD' => ['decimals' => 2, 'locale' => 'en-AU'],
			'CNY' => ['decimals' => 2, 'locale' => 'zh-CN'],
			'EUR' => ['decimals' => 2, 'locale' => 'de-DE'],
			'GBP' => ['decimals' => 2, 'locale' => 'en-GB'],
			'IDR' => ['decimals' => 0, 'locale' => 'id-ID'],
			'INR' => ['decimals' => 2, 'locale' => 'en-IN'],
			'JPY' => ['decimals' => 0, 'locale' => 'ja-JP'],
			'KRW' => ['decimals' => 0, 'locale' => 'ko-KR'],
			'NZD' => ['decimals' => 2, 'locale' => 'en-NZ'],
			'RUB' => ['decimals' => 2, 'locale' => 'ru-RU', 'useSpace' => true],
			'SGD' => ['decimals' => 2, 'locale' => 'en-SG'],
			'USD' => ['decimals' => 2, 'locale' => 'en-US'],
		];
	
		$format = $formats[$currency] ?? ['decimals' => 2, 'locale' => 'en-US'];
	
		$formattedAmount = number_format($amount, $format['decimals'], '.', ',');
	
		// Untuk RUB (₽), ubah pemisah ribuan ke spasi
		if (!empty($format['useSpace'])) {
			$formattedAmount = str_replace(',', ' ', $formattedAmount);
		}
	
		return $formattedAmount;
	}

	public function highlight(){
		$pa = "SELECT id_area, area_parent, area_url, area_name, area_status
		FROM Areas
		WHERE area_parent = 0";
		$parent = $this->modelsManager->executeQuery($pa);

		$this->view->setVar('parent', $parent);
	}
	
}

class ShoppingCart
{
    protected $session;

    public function __construct($session)
    {
        $this->session = $session;
    }

    public function addItem($item)
    {
        // Retrieve the current cart from the session
        $cart = $this->session->get('cart', []);

        // Add the new item to the cart
        $cart[] = $item;

        // Save the updated cart back to the session
        $this->session->set('cart', $cart);
    }

    public function getCart()
    {
        // Retrieve the cart from the session
        return $this->session->get('cart', []);
    }

    public function clearCart()
    {
        // Clear the cart in the session
        $this->session->remove('cart');
    }

    public function removeItem($itemId)
    {
        // Retrieve the current cart from the session
        $cart = $this->session->get('cart', []);

        // Find and remove the item with the given ID
        foreach ($cart as $key => $item) {
            if ($item['cart_id'] == $itemId) {
                unset($cart[$key]);
                break;
            }
        }

        // Save the updated cart back to the session
        $this->session->set('cart', array_values($cart));
    }

    public function updateItemQuantity($cartId, $quantity)
    {
    	if($quantity == 0){
    		$this->removeItem($cartId);
    	}
        // Retrieve the current cart from the session
        $cart = $this->session->get('cart', []);
        // Find and update the quantity of the item with the given ID
        foreach ($cart as $key => $item) {
            if ($item['cart_id'] == $cartId) {
				if($item['item_hotdeal_total'] > 0){
					$cart[$key]['item_qty'] = $quantity;
					$cart[$key]['item_hotdeal_total'] = $quantity * $cart[$key]['item_hotdeal_price'];
					break;
				} else {
					$cart[$key]['item_qty'] = $quantity;
					$cart[$key]['item_total'] = $quantity * $cart[$key]['item_price'];
					break;
				}
            }
        }

        // Save the updated cart back to the session
        $this->session->set('cart', $cart);
    }

}