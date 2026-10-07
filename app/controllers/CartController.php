<?php
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\SMTP;
use PHPMailer\PHPMailer\Exception;

class CartController extends ControllerBase
{

    public function indexAction()
    {
        // $abc=$this->session->get('cart');
        // echo "<pre>";
        // print_r($abc);
        // echo "</pre>";
        // die('');
    	$this->tag->setTitle('Review Order');
    	$headerCollection = $this->assets->collection('header');
    	$headerCollection->addCss('assets/vendor/stepper/css/bs-stepper.min.css');
        $headerCollection->addCss('assets/css/holdOn.css');
        $headerCollection->addCss('css/cart.css');
        $headerCollection->addCss('css/navbar.css');

    	$footerCollection = $this->assets->collection('footer');
        $footerCollection->addJs('https://cdn.jsdelivr.net/npm/sweetalert2@11');
        $footerCollection->addJs('assets/vendor/stepper/js/bs-stepper.min.js');
    	$footerCollection->addJs('assets/js/functions.js');
        $footerCollection->addJs('js/cart.js');
        $footerCollection->addJs('assets/js/holdOn.js');
        // $footerCollection->addJs('doku/generate_payment_url.js');
        // $footerCollection->addJs('doku/cek_payment.js');
        
        $footerCollection->addJs('https://sandbox.doku.com/jokul-checkout-js/v1/jokul-checkout-1.0.0.js');

        $q = "SELECT country_id, iso2, short_name FROM Countries ORDER BY short_name ASC";
        $countries = $this->modelsManager->executeQuery($q);
        $this->view->setVar('countries',$countries);

        $cart = $this->session->get('cart');

        $reviewStats = [];
        foreach ($cart as $val) {
            $qr = "SELECT rev.id, rev.parent_id, rev.product_id, rev.review_star, rev.review_comment, rev.review_name, rev.review_country, rev.created_at FROM Product_reviews rev WHERE product_id = '".$val['item_id']."' ORDER BY rev.created_at DESC";
        $rev = $this->modelsManager->executeQuery($qr);

        $reviewer = Product_reviews::count([
            'conditions' => 'product_id = :id: AND parent_id = 0',
            'bind' => [
                'id' => $val['item_id'],
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
            $providerId = $val['item_provider'];

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


        $reviewStats[$val['item_id']] = [
            'total_review'   => $totalReviews,
            'average_rating' => $averageRating,
            'product_rating' => $rev->review_star,
            'is_provider'    => ($reviewer == 0) ? true : false
        ];
        }

     //    //get extras
     //    $extras = array();
     //    foreach($this->session->get('cart') as $key=>$val){
     //        $row = "SELECT e.id, e.extra_name, e.extra_name_slug, e.extra_type, e.extra_value, e.sort FROM Extras_infos e LEFT JOIN Extras_infos_group eg ON eg.id_extra = e.id WHERE eg.group_product = '".$this->session->get('cart')['item_group']."' ";
     //        $extras = $this->modelsManager->executeQuery($row);
    	// }
        $this->view->setVar('reviewStats', $reviewStats);
        $this->view->pick('cart/index');
    }

    public function loadextraAction(){
        extract($_POST);
        $incoming = json_decode($extra_ids, true); // decode jadi array asosiatif

        $extrasPerCart = [];
        $rateOptionIds = [];

        foreach ($incoming as $row) {
            $rateOptionIds[] = (int)$row['id'];
            $extrasPerCart[$row['id']][] = $row['cart_id'];
        }

        $idString = implode(",", array_unique($rateOptionIds));

            
                $query = "SELECT e.id, e.extra_name, e.extra_name_slug, e.extra_type, e.extra_value, e.sort, ro.id AS id_rateopt
                        FROM Rate_options ro
                        LEFT JOIN Rates r ON ro.id_rate = r.id 
                        LEFT JOIN Products p ON r.product = p.id
                        LEFT JOIN Extras_infos_group eg ON eg.group_product = p.group_product
                        LEFT JOIN Extras_infos e ON eg.id_extra = e.id 
                        WHERE ro.id IN ($idString)
                        GROUP BY e.id, ro.id
                        ORDER BY e.sort ASC";
            
                $extras = $this->modelsManager->executeQuery($query);
            
                $arrdata = [];
                foreach($extras as $data){
            $rateOptionId = $data['id_rateopt']; // rate_option.id
            $cartIds = $extrasPerCart[$rateOptionId] ?? [];

            foreach ($cartIds as $cartId) {
                $arrdata[] = [
                    'id' => $data['id'],
                    'extra_name' => $data['extra_name'],
                    'extra_name_slug' => $data['extra_name_slug'],
                    'extra_type' => $data['extra_type'],
                    'extra_value' => $data['extra_value'],
                    'cart_id' => $cartId,
                    'rate_option_id' => $rateOptionId,
                ];
            }
        }

    
        echo json_encode($arrdata);
        $this->view->disable();
    }

    public function loadAddOnAction()
    {
        $this->view->disable();
    
        $ids = $this->request->getPost('addon_ids');
        if (!$ids) {
            echo json_encode([]);
            return;
        }
    
        $idExtras = json_decode($ids);
        if (!is_array($idExtras) || empty($idExtras)) {
            echo json_encode([]);
            return;
        }
    
        // Buat WHERE untuk filter rates
        $conditions = [];
        foreach ($idExtras as $id) {
            $id = (int)$id;
            $conditions[] = "FIND_IN_SET('$id', e.rates) > 0";
        }
        $whereClause = implode(' OR ', $conditions);
    
        // Query dari database
        $Qextras = "SELECT e.nama, e.keterangan, e.tipe, e.harga, e.rates FROM Extras e WHERE $whereClause";
        $extras = $this->modelsManager->executeQuery($Qextras);
    
        // Ambil cart dari session
        $cart = $this->session->get('cart') ?? [];
    
        $results = [];
    
        foreach ($cart as $cartItem) {
            foreach ($extras as $extra) {
                $found = false;
                if (isset($cartItem['addons']) && is_array($cartItem['addons'])) {
                    foreach ($cartItem['addons'] as $addon) {
                        if (strtolower($addon['name']) === strtolower($extra->nama)) {
                            $results[] = [
                                'id' => $addon['id'],
                                'nama' => $extra->nama,
                                'keterangan' => $extra->keterangan,
                                'tipe' => $extra->tipe,
                                'harga' => $extra->harga,
                                'rates' => $extra->rates,
                                'cart_id' => $cartItem['cart_id'],
                                'qty' => $addon['qty'],
                            ];
                            $found = true;
                            break;
                        }
                    }
                }
        
                if (!$found) {
                    $results[] = [
                        'nama' => $extra->nama,
                        'keterangan' => $extra->keterangan,
                        'tipe' => $extra->tipe,
                        'harga' => $extra->harga,
                        'rates' => $extra->rates,
                        'cart_id' => $cartItem['cart_id'],
                        'qty' => 0,
                    ];
                }
            }
        }
        
    
        echo json_encode($results);
    }
    


public function addaddonsAction()
{
    $addonsJson = $this->request->getPost('addons');
    $addons = json_decode($addonsJson, true);
    // echo "<pre>";
    //     print_r($addons);
    //     echo "</pre>";
    //     die('');

    if (!is_array($addons)) {
        return $this->response->setJsonContent([
            'status' => 'error',
            'message' => 'Invalid add-ons'
        ]);
    }

    $cart = $this->session->get('cart') ?? [];

    foreach ($addons as $addon) {
        $parent = $addon['cart_id'];

        foreach ($cart as $i => $item) {
            if ($item['cart_id'] == $parent) {
                if (!isset($cart[$i]['addons'])) {
                    $cart[$i]['addons'] = [];
                }
        
                $addonName = $addon['nama'];
                $addonHarga = (float)$addon['harga'];
                $addonQty = (int)$addon['qty'];
        
                $found = false;
        
                foreach ($cart[$i]['addons'] as $j => $existingAddon) {
                    if (strtolower($existingAddon['name']) === strtolower($addonName)) {
                        if ($addonQty <= 0) {
                            unset($cart[$i]['addons'][$j]);
                        } else {
                            $cart[$i]['addons'][$j]['qty'] = $addonQty;
                            $cart[$i]['addons'][$j]['total'] = $addonHarga * $addonQty;
                        }
                        $found = true;
                        break;
                    }
                }
        
                if (!$found && $addonQty > 0) {
                    $cart[$i]['addons'][] = [
                        'id'    => uniqid(),
                        'name' => $addonName,
                        'harga' => $addonHarga,
                        'qty' => $addonQty,
                        'total' => $addonHarga * $addonQty,
                    ];
                }
        
                // Reindex addons array untuk pastikan bersih
                $cart[$i]['addons'] = array_values($cart[$i]['addons']);
                if (empty($cart[$i]['addons'])) {
                    unset($cart[$i]['addons']);
                    }
            }
        }
        
        $this->session->set('cart', $cart);
        
    }

    $this->session->set('cart', $cart);

    return $this->response->setJsonContent([
        'status' => 'success',
        'message' => 'Add-ons updated',
    ]);
}

public function deleteAddonAction()
{
    extract($_POST);

    $cart = $this->session->get('cart', []);

    foreach ($cart as $key => $item) {
        // cek apakah ada add-on
        if (isset($item['addons'])) {
            foreach ($item['addons'] as $addonKey => $addon) {
                // remove jika id nya cocok
                if ($addon['id'] == $id) {
                    unset($cart[$key]['addons'][$addonKey]);
                    break;
                }
            }

            // reset key
            if (isset($cart[$key]['addons'])) {
                $cart[$key]['addons'] = array_values($cart[$key]['addons']);
            }

            // jika tidak ada add-on tersisa, remove array addons
            if (empty($cart[$key]['addons'])) {
                unset($cart[$key]['addons']);
            }
        }
    }

    // simpan
    $this->session->set('cart', array_values($cart));

    $shoppingCart = new ShoppingCart($this->session);
    $shoppingCart->removeItem($id);

    $this->view->disable();

}

    

    public function clearcartAction(){
        $shoppingCart = new ShoppingCart($this->session);
        $shoppingCart->clearCart();
    }

    public function removeitemAction(){
        extract($_POST);
        $shoppingCart = new ShoppingCart($this->session);
        $shoppingCart->removeItem($id);
    
        $cartItems = $this->session->get('cart');
        if (empty($cartItems)) {
            $this->session->remove('cart');
            $isCartEmpty = 1;
        } else {
            $isCartEmpty = 0;
        }
        echo $isCartEmpty;
        $this->view->disable();
    }

    public function updatecartAction(){
        extract($_POST);
        // print_r($_POST);die(''); 
        $shoppingCart = new ShoppingCart($this->session);
        if(is_array($cart_id) == true){
            foreach($cart_id as $key=>$item){
                $shoppingCart->updateItemQuantity($item, $qty[$key]);
            }
        }else{
            $shoppingCart->updateItemQuantity($cart_id, $qty);
        }

        $cartItems = $this->session->get('cart');
        if (empty($cartItems)) {
            $this->session->remove('cart');
            $isCartEmpty = 1;
        } else {
            $isCartEmpty = 0;
        }
        $this->view->disable();
    }

    public function addtocartAction()
{
    extract($_POST);
    $shoppingCart = new ShoppingCart($this->session);
    $getCart = $shoppingCart->getCart();

    $data = $data ?? [];
    $tanggal = $tanggal ?? null;

    // Tangani module string/array jadi satu format
    $data['module'] = $data['module'] ?? null;
    $module_value = is_array($data['module']) ? ($data['module'][0] ?? null) : $data['module'];

    // Paksa semua jadi array agar foreach aman
    $data['qty'] = (array)($data['qty'] ?? []);
    $data['id_rateopt'] = (array)($data['id_rateopt'] ?? []);
    $data['id_product'] = (array)($data['id_product'] ?? []);
    $data['timeselection'] = (array)($data['timeselection'] ?? []);

    // Tangani module 10 (aktivitas/sesi waktu)
    foreach ($data['qty'] as $key => $val) {
        $val = (int)$val;
        $mod = is_array($data['module']) ? ($data['module'][$key] ?? null) : $data['module'];

        if ($val > 0 && $mod == '10') {
            $idrateopt = $data['id_rateopt'][$key];
            $timeselection = $data['timeselection'][$key];

            $q = Rate_options::findFirst($idrateopt);
            if (!$q) continue;

            $optrate = $q->rate_option_name;
            $idrate = $q->id_rate;
            $unit = $q->rate_option_unit;

            $q3 = Rates::findFirst($idrate);
            $title = $q3->title;

            $q2 = Rate_availability::findFirst([
                'conditions' => 'id_rate_opt = :id: AND time_available = :time:',
                'bind' => [
                    'id' => $idrateopt,
                    'time' => $timeselection
                ]
            ]);

            $price = 0;
            if ($q2) {
                $price = $q2->publish_price;

                // Cek price breakdown
                $breakdown = $this->modelsManager->executeQuery("
                    SELECT publish_price 
                    FROM Rate_breakdown 
                    WHERE availability_id = :avail_id: 
                    AND :qty: BETWEEN qty_start AND qty_end
                    LIMIT 1
                ", [
                    'avail_id' => $q2->id,
                    'qty' => $val
                ]);

                if (count($breakdown) > 0) {
                    $price = (float)$breakdown[0]->publish_price;
                }
            }

            $total = $val * $price;

            $pr = Products::findFirst($data['id_product'][$key]);
            if (!$pr) continue;
            $product_name = $pr->name;
            $product_code = $pr->sku;
            $product_url = $pr->slug;
            $provider = $pr->provider;
            $group_product = $pr->group_product;

            // Cek hotdeal
            $hotdeal_total = $total;
            $discounted_price = $price;
            $hotdeals = $this->modelsManager->executeQuery("SELECT h.hotdeal_type, h.hotdeal_value, h.promo_status FROM Hotdeals h WHERE FIND_IN_SET($idrateopt, h.rates) > 0
            ");

            if (count($hotdeals) > 0) {
                foreach ($hotdeals as $hotdeal) {
                    if ($hotdeal->promo_status == 1) {
                        if ($hotdeal->hotdeal_type == 1) {
                            $discounted_price -= $hotdeal->hotdeal_value;
                        } else {
                            $discounted_price -= ($price * ($hotdeal->hotdeal_value / 100));
                        }
                        $discounted_price = max($discounted_price, 0);
                        $hotdeal_total = $val * $discounted_price;
                    } else {
                        $discounted_price = 0;
                        $hotdeal_total = 0;
                    }
                }
            } else {
                $discounted_price = 0;
                $hotdeal_total = 0;
            }

            // Gambar
            $pix = $this->modelsManager->executeQuery("
                SELECT f.name FROM Upload_file f
                LEFT JOIN Upload_file_morph uf ON uf.upload_file_id = f.id AND uf.related_type = 'products'
                WHERE uf.related_id = '{$data['id_product'][$key]}' LIMIT 1
            ");
            $product_pix = count($pix) > 0 ? $pix[0]->name : null;

            $shoppingCart->addItem([
                'id' => $idrateopt,
                'cart_id' => bin2hex(random_bytes(5)),
                'item_id' => $data['id_product'][$key],
                'item_group' => $group_product,
                'item' => $product_name,
                'item_code' => $product_code,
                'item_url' => $product_url,
                'item_pix' => $product_pix,
                'item_idrate' => $idrate,
                'item_rate' => $title,
                'item_idoptrate' => $idrateopt,
                'item_optrate' => $optrate,
                'item_provider' => $provider,
                'item_unit' => $unit,
                'item_qty' => $val,
                'item_price' => $price,
                'item_total' => $total,
                'item_hotdeal_price' => $discounted_price,
                'item_hotdeal_total' => $hotdeal_total,
                'tanggal' => $tanggal,
                'module' => '10',
                'timeselection' => $timeselection
            ]);
        } else if ($val > 0 && $mod == '9') {
            $idrateopt = $data['id_rateopt'][$key];
            $days = $data['days'][$key];

            $q = Rate_options::findFirst($idrateopt);
            if (!$q) continue;

            $optrate = $q->rate_option_name;
            $idrate = $q->id_rate;
            $unit = $q->rate_option_unit;

            $q3 = Rates::findFirst($idrate);
            $title = $q3->title;

            $q2 = Rate_availability::findFirst([
                'conditions' => 'id_rate_opt = :id:',
                'bind' => [
                    'id' => $idrateopt
                ]
            ]);

            $price = 0;
            if ($q2) {
                $price = $q2->publish_price;

                // cek breakdown
                $breakdown = $this->modelsManager->executeQuery("
                    SELECT publish_price 
                    FROM Rate_breakdown 
                    WHERE availability_id = :avail_id: 
                    AND :qty: BETWEEN qty_start AND qty_end
                    LIMIT 1
                ", [
                    'avail_id' => $q2->id,
                    'qty' => $val
                ]);

                if (count($breakdown) > 0) {
                    $price = (float)$breakdown[0]->publish_price;
                }
            }

            $total = $val * $price * $days;

            $pr = Products::findFirst($data['id_product'][$key]);
            if (!$pr) continue;
            $product_name = $pr->name;
            $product_code = $pr->sku;
            $product_url = $pr->slug;
            $provider = $pr->provider;
            $group_product = $pr->group_product;

            // Cek hotdeal
            $hotdeal_total = $total;
            $discounted_price = $price;
            $hotdeals = $this->modelsManager->executeQuery("
                SELECT h.hotdeal_type, h.hotdeal_value, h.promo_status 
                FROM Hotdeals h 
                WHERE FIND_IN_SET($idrateopt, h.rates) > 0
            ");

            if (count($hotdeals) > 0) {
                foreach ($hotdeals as $hotdeal) {
                    if ($hotdeal->promo_status == 1) {
                        if ($hotdeal->hotdeal_type == 1) {
                            $discounted_price -= $hotdeal->hotdeal_value;
                        } else {
                            $discounted_price -= ($price * ($hotdeal->hotdeal_value / 100));
                        }
                        $discounted_price = max($discounted_price, 0);
                        $hotdeal_total = $val * $discounted_price * $days;
                    } else {
                        $discounted_price = 0;
                        $hotdeal_total = 0;
                    }
                }
            } else {
                $discounted_price = 0;
                $hotdeal_total = 0;
            }

            // Gambar
            $pix = $this->modelsManager->executeQuery("
                SELECT f.name FROM Upload_file f
                LEFT JOIN Upload_file_morph uf ON uf.upload_file_id = f.id AND uf.related_type = 'products'
                WHERE uf.related_id = '{$data['id_product'][$key]}' LIMIT 1
            ");
            $product_pix = count($pix) > 0 ? $pix[0]->name : null;

            $start_date = $tanggal;
            $days = (int)$data['days'][$key];
            $end_date = null;

            // Hitung end_date
            if ($start_date && $days > 0) {
                $startDateObj = new DateTime($start_date);
                $start_date_formatted = $startDateObj->format('d M Y');

                $startDateObj->modify('+' . ($days - 1) . ' days');
                $end_date_formatted = $startDateObj->format('d M Y');
            }


            $shoppingCart->addItem([
                'id' => $idrateopt,
                'cart_id' => bin2hex(random_bytes(5)),
                'item_id' => $data['id_product'][$key],
                'item_group' => $group_product,
                'item' => $product_name,
                'item_code' => $product_code,
                'item_url' => $product_url,
                'item_pix' => $product_pix,
                'item_idrate' => $idrate,
                'item_rate' => $title,
                'item_idoptrate' => $idrateopt,
                'item_provider' => $provider,
                'item_optrate' => $optrate,
                'item_unit' => $unit,
                'item_qty' => $val,
                'item_price' => $price,
                'item_total' => $total,
                'item_hotdeal_price' => $discounted_price,
                'item_hotdeal_total' => $hotdeal_total,
                'tanggal' => $tanggal,
                'start_date' => $start_date_formatted,
                'end_date' => $end_date_formatted,
                'module' => '9',
                'days' => $days
            ]);
        } else if ($val > 0 && $mod == '11') {
            $idrateopt = $data['id_rateopt'][$key];

            $q = Rate_options::findFirst($idrateopt);
            if (!$q) continue;

            $optrate = $q->rate_option_name;
            $idrate = $q->id_rate;
            $unit = $q->rate_option_unit;

            $q3 = Rates::findFirst($idrate);
            $title = $q3->title;

            $q2 = Rate_availability::findFirst([
                'conditions' => 'id_rate_opt = :id:',
                'bind' => [
                    'id' => $idrateopt
                ]
            ]);

            $price = 0;
            if ($q2) {
                $price = $q2->publish_price;

                // Cek price breakdown
                $breakdown = $this->modelsManager->executeQuery("
                    SELECT publish_price 
                    FROM Rate_breakdown 
                    WHERE availability_id = :avail_id: 
                    AND :qty: BETWEEN qty_start AND qty_end
                    LIMIT 1
                ", [
                    'avail_id' => $q2->id,
                    'qty' => $val
                ]);

                if (count($breakdown) > 0) {
                    $price = (float)$breakdown[0]->publish_price;
                }
            }

            $total = $val * $price;

            $pr = Products::findFirst($data['id_product'][$key]);
            if (!$pr) continue;
            $product_name = $pr->name;
            $product_code = $pr->sku;
            $product_url = $pr->slug;
            $provider = $pr->provider;
            $group_product = $pr->group_product;

            // Cek hotdeal
            $hotdeal_total = $total;
            $discounted_price = $price;
            $hotdeals = $this->modelsManager->executeQuery("SELECT h.hotdeal_type, h.hotdeal_value, h.promo_status FROM Hotdeals h WHERE FIND_IN_SET($idrateopt, h.rates) > 0
            ");

            if (count($hotdeals) > 0) {
                foreach ($hotdeals as $hotdeal) {
                    if ($hotdeal->promo_status == 1) {
                        if ($hotdeal->hotdeal_type == 1) {
                            $discounted_price -= $hotdeal->hotdeal_value;
                        } else {
                            $discounted_price -= ($price * ($hotdeal->hotdeal_value / 100));
                        }
                        $discounted_price = max($discounted_price, 0);
                        $hotdeal_total = $val * $discounted_price;
                    } else {
                        $discounted_price = 0;
                        $hotdeal_total = 0;
                    }
                }
            } else {
                $discounted_price = 0;
                $hotdeal_total = 0;
            }

            // Gambar
            $pix = $this->modelsManager->executeQuery("
                SELECT f.name FROM Upload_file f
                LEFT JOIN Upload_file_morph uf ON uf.upload_file_id = f.id AND uf.related_type = 'products'
                WHERE uf.related_id = '{$data['id_product'][$key]}' LIMIT 1
            ");
            $product_pix = count($pix) > 0 ? $pix[0]->name : null;

            $shoppingCart->addItem([
                'id' => $idrateopt,
                'cart_id' => bin2hex(random_bytes(5)),
                'item_id' => $data['id_product'][$key],
                'item_group' => $group_product,
                'item' => $product_name,
                'item_code' => $product_code,
                'item_url' => $product_url,
                'item_pix' => $product_pix,
                'item_idrate' => $idrate,
                'item_rate' => $title,
                'item_idoptrate' => $idrateopt,
                'item_optrate' => $optrate,
                'item_provider' => $provider,
                'item_unit' => $unit,
                'item_qty' => $val,
                'item_price' => $price,
                'item_total' => $total,
                'item_hotdeal_price' => $discounted_price,
                'item_hotdeal_total' => $hotdeal_total,
                'tanggal' => $tanggal,
                'module' => '11'
            ]);
        }
    } 

    // Tangani module 1 & 2 (penginapan/hotel)
    if ($module_value == '1' || $module_value == '2') {
        $idrateopt = is_array($data['id_rateopt']) ? (int)$data['id_rateopt'][0] : (int)$data['id_rateopt'];
        $idproduct = is_array($data['id_product']) ? (int)$data['id_product'][0] : (int)$data['id_product'];
        $checkin = $data['checkin'];
        $checkout = $data['checkout'];
        $night = (int)($data['night'] ?? 1);
        $tanggal = $data['tanggal'] ?? null;
        $qty = (int)($data['qty'][0] ?? 1);

        $total_price = 0;
        $total_hotdeal_price = 0;

        $hotdeals = $this->modelsManager->executeQuery("
            SELECT h.hotdeal_type, h.hotdeal_value, h.promo_status 
            FROM Hotdeals h 
            WHERE FIND_IN_SET($idrateopt, h.rates) > 0
        ");
        $hasHotdeal = count($hotdeals) > 0 && $hotdeals[0]->promo_status == 1;
        $hotdeal = $hasHotdeal ? $hotdeals[0] : null;

        $start = new DateTime($checkin);
        $end = new DateTime($checkout);
        $period = new DatePeriod($start, new DateInterval('P1D'), $end);

        foreach ($period as $date) {
            $dateStr = $date->format('Y-m-d');

            // Ambil harga berdasarkan tanggal langsung
            $av = Rate_availability::findFirst([
                'conditions' => 'id_rate_opt = :id: AND date_available = :date:',
                'bind' => [
                    'id' => $idrateopt,
                    'date' => $dateStr
                ]
            ]);

            // Jika tidak ada data untuk tanggal tsb, fallback ke day_number
            if (!$av) {
                $dayNumber = $date->format('N'); // 1 = Senin, 7 = Minggu

                $av = Rate_availability::findFirst([
                'conditions' => 'id_rate_opt = ?0 AND day_number = ?1 AND date_available IS NULL AND rate_status != 1',
                'bind' => [$idrateopt, $dayNumber]
            ]);

            }

            $price = $av ? (float)$av->publish_price : 0;

            // cek breakdown
            if ($av) {
                $breakdown = $this->modelsManager->executeQuery("
                    SELECT publish_price 
                    FROM Rate_breakdown 
                    WHERE availability_id = :avail_id: 
                    AND :qty: BETWEEN qty_start AND qty_end
                    LIMIT 1
                ", [
                    'avail_id' => $av->id,
                    'qty' => $qty
                ]);

                if (count($breakdown) > 0) {
                    $price = (float)$breakdown[0]->publish_price;
                }
            }
            $discounted = 0;

            // Hitung diskon kalau ada hotdeal
            if ($hasHotdeal) {
                $discounted = $price;
                if ($hotdeal->hotdeal_type == 1) {
                    $discounted -= $hotdeal->hotdeal_value;
                } else {
                    $discounted -= ($price * ($hotdeal->hotdeal_value / 100));
                }
                $discounted = max($discounted, 0);
            }

            $total_price += $price;
            $total_hotdeal_price += $discounted;

        }
        // print_r($total_price);die('x');
        

        $product = Products::findFirst($idproduct);
        $rateOpt = Rate_options::findFirst($idrateopt);
        $rate = Rates::findFirst($rateOpt->id_rate);

        $pix = $this->modelsManager->executeQuery("
            SELECT f.name FROM Upload_file f
            LEFT JOIN Upload_file_morph uf ON uf.upload_file_id = f.id AND uf.related_type = 'products'
            WHERE uf.related_id = '$idproduct' LIMIT 1
        ");
        $product_pix = count($pix) > 0 ? $pix[0]->name : null;

        $shoppingCart->addItem([
            'id' => $idrateopt,
            'cart_id' => bin2hex(random_bytes(5)),
            'item_id' => $idproduct,
            'item_group' => $product->group_product,
            'item' => $product->name,
            'item_code' => $product->sku,
            'item_url' => $product->slug,
            'item_pix' => $product_pix,
            'item_provider' => $product->provider,
            'item_idrate' => $rate->id,
            'item_qty' => $qty,
            'item_rate' => $rate->title,
            'item_idoptrate' => $rateOpt->id,
            'item_optrate' => $rateOpt->rate_option_name,
            'item_unit' => $rateOpt->rate_option_unit,
            'item_price' => $total_price, // nightly
            'item_total' => $total_price * $qty,
            'item_hotdeal_price' => $total_hotdeal_price,
            'item_hotdeal_total' => $total_hotdeal_price * $qty,
            'checkin' => $checkin,
            'checkout' => $checkout,
            'night' => $night,
            'module' => $module_value
        ]);
    } 

    // Return cart count
    $cart = $shoppingCart->getCart();
    echo json_encode(count($cart));
    $this->view->disable();
}


    // public function x_makepaymentAction(){
        

    //     $client = new Client([
    //         'apiKey' => 'YOUR_API_KEY',
    //         'merchantId' => 'YOUR_MERCHANT_ID',
    //         'isProduction' => false, // Ubah menjadi true jika ingin menggunakan environment production
    //     ]);

    //     $order = [
    //         'order' => [
    //             'invoice_number' => 'INV1234567890',
    //             'amount' => 100000,
    //         ],
    //         'customer' => [
    //             'name' => 'John Doe',
    //             'email' => 'john.doe@example.com',
    //             'phone' => '08123456789',
    //         ],
    //     ];

    //     $response = $client->createInvoice($order);

    //     if ($response->status == 'SUCCESS') {
    //         header('Location: ' . $response->payment_url);
    //         exit;
    //     } else {
    //         echo 'Error: ' . $response->message;
    //     }
    // }

    // public function generatesignatureAction(){
    //     $clientId = "BRN-0234-1720869657476";
    //     $requestId = "1234567890";
    //     $requestDate = gmdate("Y-m-d H:i:s", strtotime("2024-07-16T18:00:00.000Z"));
    //     $targetPath = "https://api-sandbox.doku.com/checkout/v1/payment"; // For merchant request to Jokul, use Jokul path here. For HTTP Notification, use merchant path here
    //     $secretKey = "SK-bkSaZ1oPBGl6KbCKdhIl";
    //     $requestBody = array (
    //         'order' => array (
    //             'amount' => 15000,
    //             'invoice_number' => 'INV-20210124-0001',
    //         ),
    //         'virtual_account_info' => array (
    //             'expired_time' => 60,
    //             'reusable_status' => false,
    //             'info1' => 'Merchant Demo Store',
    //         ),
    //         'customer' => array (
    //               "id" => "JC-01",
    //               "name" => "Zolanda",
    //               "last_name" => "Anggraeni",
    //               "phone" => "628121212121",
    //               "email" => "zolanda@example.com",
    //               "address" => "taman setiabudi",
    //               "postcode" => "120129",
    //               "state" => "Jakarta",
    //               "city" => "Jakarta Selatan",
    //               "country" => "ID"
    //         )
    //     );

    //     // // Generate Digest
    //     $digestValue = base64_encode(hash('sha256', json_encode($requestBody), true));
    //     // echo "Digest: " . $digestValue;
    //     // echo "\r\n\n";

    //     // // Prepare Signature Component
    //     $componentSignature = "Client-Id:" . $clientId . "\n" . 
    //                           "Request-Id:" . $requestId . "\n" .
    //                           "Request-Timestamp:" . $requestDate . "\n" . 
    //                           "Request-Target:" . $targetPath . "\n" .
    //                           "Digest:" . $digestValue;
    //     // echo "Component Signature: \n" . $componentSignature;
    //     // echo "\r\n\n";
         
    //     // // Calculate HMAC-SHA256 base64 from all the components above
    //     $signature = base64_encode(hash_hmac('sha256', $componentSignature, $secretKey, true));
    //     // echo "Signature: " . $signature;
    //     // echo "\r\n\n";

    //     // Sample of Usage
    //     $headerSignature =  "Client-Id:" . $clientId ."\n". 
    //                         "Request-Id:" . $requestId . "\n".
    //                         "Request-Timestamp:" . $requestDate ."\n".
    //                         // Prepend encoded result with algorithm info HMACSHA256=
    //                         "Signature:" . "HMACSHA256=" . $signature;
    //     // echo "your header request look like: \n".$headerSignature;
    //     // echo "\r\n\n";
    //     echo $headerSignature;

    //     $this->view->disable();
    // }

    // public function confirmbookingAction(){
    //     extract($_POST);
    // }

    function strip_accents(string $str): string {
        if (class_exists('Normalizer')) {
            $str = Normalizer::normalize($str, Normalizer::FORM_D);
            $str = preg_replace('/\p{Mn}+/u', '', $str);
            return Normalizer::normalize($str, Normalizer::FORM_C);
        }

        $map = [
            'à' => 'a', 'á' => 'a', 'â' => 'a', 'ã' => 'a', 'ä' => 'a', 'å' => 'a',
            'è' => 'e', 'é' => 'e', 'ê' => 'e', 'ë' => 'e',
            'ì' => 'i', 'í' => 'i', 'î' => 'i', 'ï' => 'i',
            'ò' => 'o', 'ó' => 'o', 'ô' => 'o', 'õ' => 'o', 'ö' => 'o',
            'ù' => 'u', 'ú' => 'u', 'û' => 'u', 'ü' => 'u',
            'ç' => 'c', 'ñ' => 'n'
        ];

        return strtr($str, $map);
    }


    private function dokuSafeName($string) {
        $map = [
            '&' => ' and ',
            '(' => '',
            ')' => '',
            '"' => "'",
        ];
        $string = strtr($string, $map);

        return preg_replace("/[^a-zA-Z0-9.\-\/\+,=_:'@% ]/", "", $string);
    }


    public function makepaymentAction(){
        extract($_POST);
        // echo '<pre>';
        // echo json_encode($this->session->get('cart'), JSON_PRETTY_PRINT);
        // echo '</pre>';
        // die();

        $totalcart = 0;
        foreach ($this->session->get('cart') as $item) {
            if (isset($item['item_hotdeal_total']) && $item['item_hotdeal_total'] > 0) {
                // Jika ada hotdeal, tapi gak pake promo
                $totalcart += $item['item_hotdeal_total'];
            } else {
                // Gak ada promo, gak ada hotdeal → harga asli
                $totalcart += $item['item_total'];
            }

            // Tambahkan addons jika ada
            if (isset($item['addons']) && is_array($item['addons'])) {
                foreach ($item['addons'] as $addon) {
                    $totalcart += $addon['total'];
                }
            }
        }

        // print_r($totalcart);die('');
        $curr_rate = $this->session->get('currency')['rate'] ?? 1;

        if ($this->session->get('trop_auth')) {
            
            if($this->session->get('trop_auth') && $this->session->get('trop_auth')['customer_id'] != 'google'){

                $row = Customers::findFirst([
                    'conditions' => 'email = :email:',
                    'bind'       => ['email' => $data['email']]
                ]);
        
                if($row){
                    //get customer info
                    $email = $row[0]['email'];
                    $custid = $row[0]['id'];
                    $phone = str_replace("+","",$row[0]['phone']);
                    $name = $row[0]['name'];
                    $country = $row[0]['country'];
        
                }else{
        
                    //insert new customer
                    $password = bin2hex(random_bytes(8));
                    $hashedPassword = password_hash($password, PASSWORD_DEFAULT);
                    $hash_id = sha1($data['cust_name'] . $data['email'] . time());
        
                    // $ins = new Customers();
                    // $ins->name = $data['first_name'] . ' ' . $data['last_name'];
                    // $ins->email = $data['email'];
                    // $ins->password = $hashedPassword; // Simpan password hash
                    // $ins->phone = $data['phone_number'];
                    // $ins->country = $data['country'];
                    // $state = $ins->save();
        
                    $ins = new Customers();
                    $ins->hash_id = $hash_id;
                    $ins->customer_status = 1;  
                    $ins->name = $data['cust_name'];
                    $ins->email = $data['email'];
                    $ins->password = $hashedPassword;
                    $ins->phone = $data['phone_number'];
                    $ins->country = $data['country'];
                    $state = $ins->save();
        
                    if ($state) {
                        require '../vendor/autoload.php';
                        // data untuk dikirim ke mailer
                        $protocol = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off' || $_SERVER['SERVER_PORT'] == 443) ? "https://" : "http://";
                        $host = $_SERVER['HTTP_HOST'];
                        $baseUrl = $this->url->getBaseUri();
                        $fullBaseUrl = $protocol . $host . $baseUrl;
                        $login_link = $fullBaseUrl . 'account/login/';
        
                        $cust_name = $ins->name;
                        $cust_email = $ins->email;
        
        
                            $createAccount[] = [
                                'name' => $cust_name, 
                                'email' => $cust_email, 
                                'password' => $password,
                                'login_link' => $login_link,
                            ];
        
                        // Kirim data ke MailController
                        $mailService = $this->di->get('mail');
                        $result = $mailService->createAccountAction($createAccount);
        
                        //get customer info
                        $email = $data['email'];
                        $custid = $ins->id;
                        $phone = str_replace("+","",$data['phone_number']);
                        $name = $data['cust_name'];
                        $country = $data['country'];   
                    }         
        
                }
            } else {

                $email = $data['email'];
                $custid = 'google_' . uniqid();
                $phone = str_replace("+","",$data['phone_number']);
                $name = $data['cust_name'];
                $country = $data['country'];  
            }
        } else {
            $row = Customers::findFirst([
                    'conditions' => 'email = :email:',
                    'bind'       => ['email' => $data['email']]
                ]);
        
                if($row){
                    //get customer info
                    $email = $row->email;
                    $custid = $row->id;
                    $phone = str_replace("+","",$row->phone);
                    $name = $row->name;
                    $country = $row->country;
        
                }else{
        
                    //insert new customer
                    $password = bin2hex(random_bytes(8));
                    $hashedPassword = password_hash($password, PASSWORD_DEFAULT);
                    $hash_id = sha1($data['cust_name'] . $data['email'] . time());
        
                    // $ins = new Customers();
                    // $ins->name = $data['first_name'] . ' ' . $data['last_name'];
                    // $ins->email = $data['email'];
                    // $ins->password = $hashedPassword; // Simpan password hash
                    // $ins->phone = $data['phone_number'];
                    // $ins->country = $data['country'];
                    // $state = $ins->save();
        
                    $ins = new Customers();
                    $ins->hash_id = $hash_id;
                    $ins->customer_status = 1;  
                    $ins->name = $data['cust_name'];
                    $ins->email = $data['email'];
                    $ins->password = $hashedPassword;
                    $ins->phone = $data['phone_number'];
                    $ins->country = $data['country'];
                    $state = $ins->save();
        
                    if ($state) {
                        require '../vendor/autoload.php';
                        // data untuk dikirim ke mailer
                        $protocol = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off' || $_SERVER['SERVER_PORT'] == 443) ? "https://" : "http://";
                        $host = $_SERVER['HTTP_HOST'];
                        $baseUrl = $this->url->getBaseUri();
                        $fullBaseUrl = $protocol . $host . $baseUrl;
                        $login_link = $fullBaseUrl . 'account/login/';
        
                        $cust_name = $ins->name;
                        $cust_email = $ins->email;
        
        
                            $createAccount[] = [
                                'name' => $cust_name, 
                                'email' => $cust_email, 
                                'password' => $password,
                                'login_link' => $login_link,
                            ];
        
                        // Kirim data ke MailController
                        $mailService = $this->di->get('mail');
                        $result = $mailService->createAccountAction($createAccount);
        
                        //get customer info
                        $email = $data['email'];
                        $custid = $ins->id;
                        $phone = str_replace("+","",$data['phone_number']);
                        $name = $data['cust_name'];
                        $country = $data['country'];   
                    }         
        
                }
        }
        


        //order & detail sections
        $order = new Orders;
        $order->code = $this->generate_random_sku(8);
        // $order->voucher_number = '';
        $order->customer_email = $email;
        $order->customer_name = $data['cust_name'];
        $order->customer_country = $data['country'];
        $order->customer_phone = $data['phone_number'];
        $order->currency = $this->session->get('currency')['converted'];
        $order->total = $data['total'] * $curr_rate;
        $order->status = 'new';
        $state2 = $order->save();
        if($state2){
            //insert detail order
            //looping item
            $arr_detail = array();
            // $val['item_idoptrate'] = '';
            // print_r($this->session->get('cart'));
            $cartDetailMap = []; // mapping cart_id ke order_detail_id
            foreach($this->session->get('cart') as $key=>$val){
                // echo "Processing item: " . print_r($val, true) . "\n"; echo "<hr>";

                $item_prov = Providers::findFirst([
                    'conditions' => 'id = :id:',
                    'bind' => ['id' => $val['item_provider']]
                ]);
            if($val['module'] == '10') {
                $detail = new Order_details;
                $detail->module = $val['module'];
                $detail->provider_name = $item_prov->name;
                $detail->provider = $val['item_provider'];
                $detail->product_name = $val['item'];
                $detail->quantity = $val['item_qty'];
                if ($val['item_hotdeal_price'] == 0){
                    $detail->product_price = $val['item_price'] * $curr_rate;
                    $detail->subtotal_price = $val['item_total'] * $curr_rate;    
                } else {
                    $detail->product_price = $val['item_hotdeal_price'] * $curr_rate;
                    $detail->subtotal_price = $val['item_hotdeal_total'] * $curr_rate;
                }
                $detail->order_id = $order->id;
                $detail->product = $val['item_id'];
                $detail->detail_status = 'new';
                $detail->id_rate = $val['item_idrate'];
                $detail->rate_name = $val['item_rate'];
                $detail->id_opt_rate = $val['item_idoptrate'];
                $detail->rate_opt_name = $val['item_optrate'];
                $detail->order_date = $val['tanggal'];
                $detail->order_time = $val['timeselection'];
                $detail->order_days = 1;
            } else if($val['module'] == '1' || $val['module'] == '2'){
                $detail = new Order_details;
                $detail->module = $val['module'];
                $detail->provider_name = $item_prov->name;
                $detail->provider = $val['item_provider'];
                $detail->product_name = $val['item'];
                $detail->quantity = $val['item_qty'];
                if ($val['item_hotdeal_price'] == 0){
                    $detail->product_price = $val['item_price'] * $curr_rate;
                    $detail->subtotal_price = $val['item_total'] * $curr_rate;    
                } else {
                    $detail->product_price = $val['item_hotdeal_price'] * $curr_rate;
                    $detail->subtotal_price = $val['item_hotdeal_total'] * $curr_rate;
                }
                $detail->order_id = $order->id;
                $detail->product = $val['item_id'];
                $detail->detail_status = 'new';
                $detail->id_rate = $val['item_idrate'];
                $detail->rate_name = $val['item_rate'];
                $detail->id_opt_rate = $val['item_idoptrate'];
                $detail->rate_opt_name = $val['item_optrate'];
                $detail->order_days = $val['night'];
                $dateString = $val['checkin']; 
                $date = DateTime::createFromFormat('d M Y', $dateString);
                $detail->order_date = $date ? $date->format('Y-m-d') : null;

            } else if($val['module'] == '9') {
                $detail = new Order_details;
                $detail->module = $val['module'];
                $detail->provider_name = $item_prov->name;
                $detail->provider = $val['item_provider'];
                $detail->product_name = $val['item'];
                $detail->quantity = $val['item_qty'];
                if ($val['item_hotdeal_price'] == 0){
                    $detail->product_price = $val['item_price'] * $curr_rate;
                    $detail->subtotal_price = $val['item_total'] * $curr_rate;    
                } else {
                    $detail->product_price = $val['item_hotdeal_price'] * $curr_rate;
                    $detail->subtotal_price = $val['item_hotdeal_total'] * $curr_rate;
                }
                $detail->order_id = $order->id;
                $detail->product = $val['item_id'];
                $detail->detail_status = 'new';
                $detail->id_rate = $val['item_idrate'];
                $detail->rate_name = $val['item_rate'];
                $detail->id_opt_rate = $val['item_idoptrate'];
                $detail->rate_opt_name = $val['item_optrate'];
                $detail->order_date = $val['tanggal'];
                $detail->order_days = $val['days'];
            } else if($val['module'] == '11') {
                $detail = new Order_details;
                $detail->module = $val['module'];
                $detail->provider_name = $item_prov->name;
                $detail->provider = $val['item_provider'];
                $detail->product_name = $val['item'];
                $detail->quantity = $val['item_qty'];
                if ($val['item_hotdeal_price'] == 0){
                    $detail->product_price = $val['item_price'] * $curr_rate;
                    $detail->subtotal_price = $val['item_total'] * $curr_rate;    
                } else {
                    $detail->product_price = $val['item_hotdeal_price'] * $curr_rate;
                    $detail->subtotal_price = $val['item_hotdeal_total'] * $curr_rate;
                }
                $detail->order_id = $order->id;
                $detail->product = $val['item_id'];
                $detail->detail_status = 'new';
                $detail->id_rate = $val['item_idrate'];
                $detail->rate_name = $val['item_rate'];
                $detail->id_opt_rate = $val['item_idoptrate'];
                $detail->rate_opt_name = $val['item_optrate'];
                $detail->order_date = $val['tanggal'];
            }
                $st = $detail->save(); 
                
                if(!$st){
                    print_r($detail->getMessages());
                }else{
                    $cartDetailMap[$val['cart_id']] = $detail->id;

                    // update jumlah ordered
                    $ordered_product = Products::findFirst($val['item_id']);
                    if ($ordered_product) {
                        $ordered_product->ordered += (int)$val['item_qty'];
                        $ordered_product->save();
                    }
                }

                
                //get array of items
            $arr_detail = [];
            $addon_details = [];

            foreach ($this->session->get('cart') as $key => $val) {
                $qty = (int)$val['item_qty'];
                

                // Pakai harga hotdeal jika ada, kalau tidak pakai item_price
                if($val['module'] == '9'){
                    if (isset($val['discount']) && $val['discount'] > 0) {
                        if (isset($val['item_hotdeal_price']) && $val['item_hotdeal_price'] > 0) {
                            $baseUnitPrice = (float)$val['item_hotdeal_price'];
                        } else {
                            $baseUnitPrice = (float)$val['item_price'];
                        }

                        $basePrice = ($baseUnitPrice * $val['days']) - ((float)$val['discount'] / $qty);
                    } else {
                        if (isset($val['item_hotdeal_price']) && $val['item_hotdeal_price'] > 0) {
                            $basePrice = (float)$val['item_hotdeal_price'] * $val['days'];
                        } else {
                            $basePrice = (float)$val['item_price'] * $val['days'];
                        }
                    }

                } else {
                    $basePrice = isset($val['discount']) && $val['discount'] > 0
                        ? ((isset($val['item_hotdeal_price']) && $val['item_hotdeal_price'] > 0
                            ? (float)$val['item_hotdeal_price']
                            : (float)$val['item_price']) - ((float)$val['discount']) / $qty)
                        : (isset($val['item_hotdeal_price']) && $val['item_hotdeal_price'] > 0
                            ? (float)$val['item_hotdeal_price']
                            : (float)$val['item_price']);
                }

                        $details = Order_details::find([
                        'conditions' => 'order_id = :oid:',
                        'bind' => ['oid' => $order->id],
                        'order' => 'id ASC'
                    ]);

                    // map item_id + cart_id ke order_detail_id
                    $detailMap = [];
                    foreach ($details as $d) {
                        $detailMap[] = $d->id; // key bisa disesuaikan
                    }

                    $detailsList = $details->toArray();

                    $order_detail_id = $detailsList[$key]['id'] ?? null;

                // Masukkan item utama
                $arr_detail[] = [
                    'order_detail_id' => $order_detail_id,
                    'item_id' => $val['item_id'],
                    'cart_id' => $val['cart_id'],
                    'id' => $val['id'],
                    'name' => $this->dokuSafeName($val['item_code'] . '/' . $val['item'] . '/' . $val['item_rate'] . '/' . $val['item_optrate']),
                    'price' => (int)$basePrice,
                    'quantity' => $qty,
                    'sku' => $val['item_code'],
                    'tanggal' => $val['tanggal'] ?? null,
                    'timeselection' => $val['timeselection'] ?? null,
                    'check-in' => $val['checkin'] ?? null,
                    'check-out' => $val['checkout'] ?? null,
                    'days' => $val['days'] ?? null,
                    'module' => $val['module']
                ];

                // Addons sebagai line_items terpisah
                if (isset($val['addons']) && is_array($val['addons'])) {
                    foreach ($val['addons'] as $addon) {
                        $addon_details[] = [
                            'id' => 'ADDON-' . strtoupper(preg_replace('/\s+/', '-', $this->dokuSafeName($addon['name']))),
                            'name' => $this->dokuSafeName('Add-on: ' . $addon['name'] . ' -' . $val['item'] . ''),
                            'price' => (int)$addon['harga'],
                            'quantity' => (int)$addon['qty']
                        ];
                    }
                }
            }

            }

            foreach ($data as $extra_key => $extra_value) {
                if (strpos($extra_key, 'extras_') === 0) {
                    
                    if (empty($extra_value)) {
                        continue;
                    }

                    if (!is_array($extra_value)) {
                        $extra_value = [$extra_value];
                    }

                    $suffix = substr($extra_key, strlen('extras_'));
                    $parts = explode('_', $suffix);
                    $cart_id = end($parts);       // ambil cart_id
                    array_pop($parts);            // buang cart_id
                    $extras_idrateopt = array_pop($parts); // buang id rateopt
                    $extras_name = implode('_', $parts);   // sisanya nama extras

                    $e = Extras_infos::findFirst([
                        'conditions' => 'extra_name_slug = :extra_name_slug:',
                        'bind' => ['extra_name_slug' => $extras_name]
                    ]);

                    if ($e && isset($cartDetailMap[$cart_id])) {
                        foreach ($extra_value as $valExtra) {
                            $ins = new Extras_infos_orderdetail;
                            $ins->order_detail_id = $cartDetailMap[$cart_id]; // pakai mapping
                            $ins->id_extra = $e->id;
                            $ins->extra_info_value = $valExtra;
                            if(!$ins->save()){
                                print_r($ins->getMessages());
                            }
                        }
                    }
                }
            }
            
        }

        // echo '<pre>';
        // echo json_encode($arr_detail, JSON_PRETTY_PRINT);
        // echo '</pre>';
        // die();
        // die('stop..');
        $totalDiscount = 0;
        foreach ($this->session->get('cart') as $item) {
            if (isset($item['discount']) && $item['discount'] > 0) {
                $totalDiscount += $item['discount'];
            }
        }

        $po = $totalcart - $totalDiscount;
        // print_r($po);die('');
        
            //     //end confirm booking        
        $baseUrl = $this->url->getBaseUri();
        $line_items = array_merge($arr_detail, $addon_details);

        if (!mb_check_encoding($name, 'UTF-8')) {
            $name = mb_convert_encoding($name, 'UTF-8', 'auto');
        }
        $custNameForGateway = $this->strip_accents($name);
        //  echo '<pre>';
        //         echo json_encode($line_items, JSON_PRETTY_PRINT);
        //         echo '</pre>';
        //         die();
        $requestBody = array(
            'order' => array(
                "amount" => $totalcart - $totalDiscount,
                "invoice_number" => $order->code,
                "currency" => "IDR",
                "session_id" => "f3cc59e620c54b2aaa773f6ed6a98895",
                "discount_amount" => $totalDiscount,
                // "callback_url" => "https://tropialis.com/cart/",
                "callback_url_cancel" => $baseUrl,
                "line_items" => $line_items,
    //                 // "line_items" => array(
    //                 //     [
    //                 //         "name" => "Fresh flowers",
    //                 //         "quantity" => 1,
    //                 //         "price" => "40000",
    //                 //         "sku" => "FF01",
    //                 //         "category" => "gift-and-flowers",
    //                 //         "url" => "http://doku.com/",
    //                 //         "image_url" => "http://doku.com/",
    //                 //         "type" => "ABC"
    //                 //     ],
    //                 //     [
    //                 //         "name" => "T-shirt",
    //                 //         "quantity" => 1,
    //                 //         "price" => "40000",
    //                 //         "sku" => "T01",
    //                 //         "category" => "clothing",
    //                 //         "url" => "http://doku.com/",
    //                 //         "image_url" => "http://doku.com/",
    //                 //         "type" => "ABC"
    //                 //     ]
    //                 // ),
                "language" => "EN",
                "disable_retry_payment" => true,
                "auto_redirect" => true
            ),
            'payment' => array(
                "payment_method_types" => [
                        "CREDIT_CARD",
                        "VIRTUAL_ACCOUNT_BCA",
                        "VIRTUAL_ACCOUNT_BANK_PERMATA",
                        "VIRTUAL_ACCOUNT_BANK_DANAMON",
                        "VIRTUAL_ACCOUNT_BANK_CIMB",
                        "VIRTUAL_ACCOUNT_BANK_MANDIRI",
                        "VIRTUAL_ACCOUNT_DOKU",
                        "VIRTUAL_ACCOUNT_BNI",
                        "VIRTUAL_ACCOUNT_BRI",
                        "VIRTUAL_ACCOUNT_BANK_SYARIAH_MANDIRI"
                    ],
                    "payment_due_date" => 1440
    //                 // "token_id" => "f3cc59e620c54b2aaa773f6ed6a9889520232902162906009",
    //                 // "url" => "https://app-uat.doku.com/checkout/link/f3cc59e620c54b2aaa773f6ed6a9889520232902162906009",
    //                 // "expired_date" => "20230302192904"
            ),
            'customer' => array(
                "id" => $custid,
                "email" => $email,
                "phone" => $phone,
                "name" => $custNameForGateway,
                "country" => $country
            ),
            'uuid' => '2225230302162905985107180586827000113908',
        );

        $requestId = rand(1, 100000); // Change to UUID or anything that can generate unique value
        $dateTime = gmdate("Y-m-d H:i:s");
        $isoDateTime = date(DATE_ISO8601, strtotime($dateTime));
        $dateTimeFinal = substr($isoDateTime, 0, 19) . "Z";
        $clientId = $this->config->payment->clientID; // Change with your Client ID
        $secretKey = $this->config->payment->secretKey; // Change with your Secret Key
        // die($dateTimeFinal);
        $getUrl = $this->config->payment->dokuUrl;

        $targetPath = '/checkout/v1/payment';
        $url = $getUrl . $targetPath;

        // Generate digest
        $digestValue = base64_encode(hash('sha256', json_encode($requestBody), true));

        // Prepare signature component
        $componentSignature = "Client-Id:".$clientId ."\n".
                            "Request-Id:".$requestId . "\n".
                            "Request-Timestamp:".$dateTimeFinal ."\n".
                            "Request-Target:".$targetPath ."\n".
                            "Digest:".$digestValue;

    //     // Generate signature
        $signature = base64_encode(hash_hmac('sha256', $componentSignature, $secretKey, true));

    //     // Execute request
        $ch = curl_init($url);
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($requestBody));
        curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type:application/json'));
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

        curl_setopt($ch, CURLOPT_HTTPHEADER, array(
            'Content-Type: application/json',
            'Client-Id:' . $clientId,
            'Request-Id:' . $requestId,
            'Request-Timestamp:' . $dateTimeFinal,
            'Signature:' . "HMACSHA256=" . $signature,
        ));
    //     // Set response json
        $responseJson = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        // print_r($arr_detail);die(' x');
        // die($responseJson);
        // print_r($responseJson);die(' x');
        curl_close($ch);

    //     // Echo the response
    //     if (is_string($responseJson) && $httpCode == 200) {
    //         // echo $responseJson;
    //         return json_decode($responseJson, true);
    //     } else {
    //         // echo $responseJson;
    //         return null;
    //     }

        //send mail -- kirim email disini
        require '../vendor/autoload.php';

        $orderCode = $order->code;
        $custPhone = $phone;
        $custName = $order->customer_name;
        $email = $order->customer_email;

        $contries = Countries::findFirst([
            'conditions' => 'iso2 = :iso2:',
            'bind' => ['iso2' => $order->customer_country],
        ]);

        $custCountry = $contries->short_name;
        
        //get payment url
        $doko = json_decode($responseJson, true);
        // die($doko['response']['payment']['url']);
        // Ambil semua nama produk dari keranjang
        $orderDetails = [];
        foreach ($arr_detail as $key => $ar) {//NOTE PERLU DI BUAT ULANG AMBIL DARI VARIABLE $arr_detail diatas, di looping ini hanya dari data session, sedangkan di $arr_detail sudah di insert ke database

            $currency = $this->session->get('currency')['converted'] ?? 'IDR';

            $orderDetails[] = [
                'id' => rawurldecode($ar['order_detail_id']),
                'item_id' => rawurldecode($ar['item_id']),
                'cart_id' => rawurldecode($ar['cart_id']),
                'product_name' => rawurldecode($ar['name']), 
                'module' => rawurldecode($ar['module']), 
                'product_qty' => rawurldecode($ar['quantity']), 
                'product_price' => rawurldecode($ar['price']), 
                'total' => $totalcart - $totalDiscount, 
                'selected_currency' => $currency, 
                'orderCode' => $orderCode,
                'phone' => $custPhone,
                'country' => $custCountry,
                'name' => $custName,
                'email' => $email,
                'tanggal' => rawurldecode($ar['tanggal']) ?? null,
                'timeselection' => rawurldecode($ar['timeselection']) ?? null,
                'checkin' => rawurldecode($ar['check-in']) ?? null,
                'checkout' => rawurldecode($ar['check-out']) ?? null,
                'days' => rawurldecode($ar['days']) ?? null,
                'link_payment' => $doko['response']['payment']['url']
            ];
        }

        // Kirim data ke MailController
        $mailService = $this->di->get('mail');
        $result = $mailService->sendAction($orderDetails);
        //  buat disini -- destroy cart session 
        if ($this->session->has('cart')) {
            $this->session->remove('cart');
        }
        if (is_string($responseJson) && $httpCode == 200) {
            echo $responseJson;
        } else {
            echo json_encode([
                'status' => 'error',
                'message' => 'Failed to get payment link from DOKU',
                'doku_response' => $responseJson
            ]);
        }
        $this->view->disable();

}

    public function successAction(){
        extract($_GET);
        $paymentId = $this->dispatcher->getParam('paymentId');
        $paymentlink = $this->config->payment->paymentLink;
        $paymentUrl = $paymentlink.$paymentId;
        $footerCollection = $this->assets->collection('footer');
        $footerCollection->addJs('js/success.js');
        $footerCollection->addJs($this->config->payment->jokulLib);
        $this->view->setVar('paymenturl',$paymentUrl);
        $this->tag->setTitle('Order confirmed successfully');
        $this->view->pick("cart/success");
    }

    public function promotionAction()
{
    extract($_POST);
    // print_r($_POST);die();

    $cek_promo = Promotions::findFirst([
        'conditions' => 'promo_code = :promo_code:',
        'bind' => ['promo_code' => $promo_code]
    ]);

    if (!$cek_promo || $cek_promo->promo_status == 0) {
        echo json_encode(['status' => 'danger', 'text' => 'Failed to apply promotion code!']);
        exit;
    }

    $cart = $this->session->get('cart', []);
    $totalcart = 0;
    $discount = 0;
    $newTotal = 0;
    $product_names = [];
    $detailed_discounts = [];
    $promo_applied = false;

    $promo_rate_ids = array_map('trim', explode(',', $cek_promo->rates));

    foreach ($cart as $key => $item) {
        if (!is_array($item)) continue;

        $item_total = 0;
        $disc = 0;

        if ($item['module'] == '1' || $item['module'] == '2') {
            $item_total = ($item['item_hotdeal_total'] > 0) ? $item['item_hotdeal_total'] : $item['item_total'];
        }else { 
            $item_price = ($item['item_hotdeal_price'] > 0) ? $item['item_hotdeal_price'] : $item['item_price'];
            $item_total = $item_price;
        }

        $totalcart += $item_total;
    // print_r($totalcart);die();

        if (in_array($item['item_idoptrate'], $promo_rate_ids)) {
            $promo_applied = true;

            if ($cek_promo->promo_type == 'number') {
                $disc = (float)$cek_promo->promo_value;
            } elseif ($cek_promo->promo_type == 'percentage') {
                $disc = ($cek_promo->promo_value / 100) * $item_total;
            }

            if($item['module'] == '9'){
                $disc = min($disc, $item_total) * $item['item_qty'] * $item['days'];
                $discount += $disc;
            } elseif($item['module'] == '1' || $item['module'] == '2'){
                $disc = min($disc, $item_total);
                $discount += $disc;
            } else {
                $disc = min($disc, $item_total) * $item['item_qty'];
                $discount += $disc;
            }

            $cart[$key]['promo_value'] = $cek_promo->promo_value;
            $cart[$key]['discount'] = $disc;
            $cart[$key]['new_total'] = $item_total - $disc;

            $rateOpt = Rate_options::findFirstById($item['item_idoptrate']);
            if ($rateOpt) {
                $rate = Rates::findFirstById($rateOpt->id_rate);
                if ($rate) {
                    $product = Products::findFirstById($rate->product);
                    if ($product) {
                        if (!in_array($product->name, $product_names)) {
                            $product_names[] = $product->name;
                        }
                        $detailed_discounts[] = [
                            'product_name' => $product->name,
                            'discount' => $disc
                        ];
                    }
                }
            }
            
        } else {
            $cart[$key]['promo_value'] = 0;
            $cart[$key]['discount'] = 0;
            $cart[$key]['new_total'] = $item_total;
        }
    }

    if (!$promo_applied) {
        echo json_encode(['status' => 'danger', 'text' => 'Failed to apply promotion code!.']);
        exit;
    }

    $newTotal = 0;
    foreach ($cart as $item) {
        if (is_array($item) && isset($item['new_total'])) {
            $newTotal += $item['new_total'];
        }
    }

    $this->session->set('cart', $cart);

    echo json_encode([
        'status' => 'success',
        'discount' => (float)$discount,
        'new_total' => (float)$newTotal,
        'total' => (float)$totalcart,
        'grand_total' => (float)$total,
        'promo_type' => $cek_promo->promo_type,
        'promo_value' => (float)$cek_promo->promo_value,
        'text' => 'Promo code applied successfully',
        'product_name' => implode(', ', $product_names),
        'detailed_discounts' => $detailed_discounts
    ]);
    exit;
}

}