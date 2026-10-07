<?php

class IndexController extends ControllerBase
{
    public function sitemapAction()
    {
        $this->response->setContentType('application/xml', 'UTF-8');

        // Example: Add dynamic product/activity pages
        $activities = [
            ['slug' => 'packages'],
            ['slug' => 'attractions'],
            ['slug' => 'fast-boat'],
            ['slug' => 'airport-transfer'],
            ['slug' => 'activities'],
            ['slug' => 'car-charter'],
            ['slug' => 'mobile-beauty-treatment'],
            ['slug' => 'mobile-massage'],
            ['slug' => 'spa-and-salon'],
            ['slug' => 'water-actiity'],
            ['slug' => 'bike-rental'],
            ['slug' => 'camping-equipments'],
            ['slug' => 'food-and-dining'],
            ['slug' => 'villas']
        ];

        foreach ($activities as $a) {
            $urls[] = [
                'loc' => 'https://www.tropialis.com/category/'.$a['slug'].'/',
                'priority' => '0.9',
                'changefreq' => 'weekly',
            ];
        }

        $xml = '<?xml version="1.0" encoding="UTF-8"?>';
        $xml .= '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">';
        $xml .= '<url>';
        $xml .= '<loc>https://www.tropialis.com/</loc>';
        $xml .= '<changefreq>weekly</changefreq>';
        $xml .= '<priority>0.9</priority>';
        $xml .= '</url>';
        foreach ($urls as $url) {
            $xml .= '<url>';
            $xml .= '<loc>' . htmlspecialchars($url['loc']) . '</loc>';
            $xml .= '<changefreq>' . $url['changefreq'] . '</changefreq>';
            $xml .= '<priority>' . $url['priority'] . '</priority>';
            $xml .= '</url>';
        }

        $xml .= '</urlset>';

        $this->response->setContent($xml);
        return $this->response;
    }

    public function indexAction()
    {
        $area_selected = $this->session->get('areas')['display'];
        $this->tag->setTitle('Book '.$area_selected.' Activities, Tours & Things To Do');
        $metadesc = "Find and book the best ".$area_selected." activities, tours, and unique experiences in ".$area_selected." with Tropialis. Discover top things to do across beaches, culture, and adventure";
        $this->view->setVar('metadesc',$metadesc);
        $footerCollection = $this->assets->collection('footer');
        $footerCollection->addJs('js/index.js');
        // Prepare structured data (JSON-LD)
        //create a looping item
        $this->view->schemaJson = json_encode([
          "@context"=> "https://schema.org",
          "@type"=> "TravelAgency",
          "@id"=> "https://www.tropialis.com",
          "name"=> "Tropialis",
          "url"=> "https://www.tropialis.com",
          "logo"=> "https://www.tropialis.com/img/logo_square.png",
          "image"=> "https://www.tropialis.com/img/logo.png",
          "description"=> $metadesc,
          "slogan"=> "One-stop booking solutions",
          "founder"=> [
            "@type"=> "Person",
            "name"=> "Tropialis Team"
          ],
          "sameAs"=> [
            "https://web.facebook.com/profile.php?id=61565075641195",
            "https://www.instagram.com/tropialisparadise/",
            "https://www.tiktok.com/@tropialis.exotic"
          ],
          "address"=> [
            "@type"=> "PostalAddress",
            "streetAddress"=> "Jl. Srikandi No. 50",
            "addressLocality"=> "Nusa Dua",
            "addressRegion"=> "Bali",
            "postalCode"=> "80363",
            "addressCountry"=> "ID"
          ],
          "contactPoint"=> [
            "@type"=> "ContactPoint",
            "telephone"=> "+62-881-0373-36399",
            "contactType"=> "Customer service",
            "areaServed"=> "ID",
            "availableLanguage"=> ["English", "Indonesian"]
          ]
        ], JSON_UNSCAPED_SLASHES | JSON_PRETTY_PRINT);
    }

    public function changecurrencyAction(){
		extract($_POST);
        $date = date("Y-m-d");
        // print_r($date);  
        if (!$this->session->has('currency')) {
            $this->session->set('currency', [
                'base' => 'IDR',
                'converted' => 'IDR',
                'rate' => 1
            ]);
        }        
        //check if existing day rate exist or not
        $cek = Currencies_daily_rate::findFirst([
            'conditions' => 'date = :date:',
            'bind' => ['date' => $date],
        ]);
        if($cek == false){
            //insert daily rate
            //START BAGIAN INI AKAN DIPINDAH KE CRONJOB
            //https://v6.exchangerate-api.com/v6/2c9bc54de77206ca5f958d73/latest/IDR
            // Fetching JSON
            $base_curr = $this->config->currency->base;
            $api_key = $this->config->currency->api;
            $req_url = 'https://v6.exchangerate-api.com/v6/'.$api_key.'/latest/'.$base_curr;
            $response_json = file_get_contents($req_url);
            // Continuing if we got a result
            if(false !== $response_json) {
                // Try/catch for json_decode operation
                try {
                    // Decoding
                    $response = json_decode($response_json);
                    // Check for success
                    if('success' === $response->result) {
                        foreach($response->conversion_rates as $currency=>$rate){
                            $ins = new Currencies_daily_rate;
                            $ins->iso3 = $currency;
                            $ins->date = $date;
                            $ins->conversion_rate = $rate;
                            $ins->update_date = date("Y-m-d H:i:s");
                            $ins->save();
                        }

                    }

                }
                catch(Exception $e) {
                    // Handle JSON parse error...
                    echo 'Get daily rate is error!';
                }

            }
            //END BAGIAN INI AKAN DIPINDAH KE CRONJOB
        }
        //get converted rate
        $d = Currencies_daily_rate::findFirst([
            'conditions' => 'date = :date: AND iso3 = :iso3:',
            'bind' => ['date' => $date, 'iso3' => $curr],
        ]);

        //get country flag
        $f = Currencies::findFirst([
            'conditions' => 'iso3 = :iso3:',
            'bind' => ['iso3' => $curr],
        ]);

        $this->session->set('currency', [
            'base' => 'IDR',
            'converted' => $curr,
            'rate' => $d->conversion_rate
        ]);
        
        echo json_encode(array('curr'=>$curr,'rate'=>$d->conversion_rate, 'flag' => $f->flag));
        $this->view->disable();
	}

    public function changeareasAction(){
        extract($_POST);
        // print_r($_POST);die();

        $areas = Areas::findFirst([
            'conditions' => 'area_url = :area_url:',
            'bind' => ['area_url' => $area]
        ]);

		$this->session->set('areas', [
			'default' => 'bali',
			'selected' => $area,
            'display' => $areas->area_name
		]);

        echo json_encode(array('area'=>$area, 'display_area'=> $areas->area_name));

        $this->view->disable();
    }

    public function enquiryAction()
{
    $this->view->disable();

    $captcha = $this->request->getPost('g-recaptcha-response', 'string');

    if (!$captcha) {
        return $this->response->setJsonContent([
            'status' => 'error',
            'message' => 'Captcha not verified'
        ]);
    }

    // Verify ke Google
    $secretKey = $this->config->captcha->secretKey;
    $verifyURL = "https://www.google.com/recaptcha/api/siteverify?secret={$secretKey}&response={$captcha}";
    $verifyResponse = file_get_contents($verifyURL);
    $responseData = json_decode($verifyResponse);

    if (!$responseData->success) {
        return $this->response->setJsonContent([
            'status' => 'error',
            'message' => 'Captcha verification failed'
        ]);
    }

    extract($_POST);

    $find_country = Countries::findFirst([
        'conditions' => 'iso2 = :country:',
        'bind' => ['country' => $country]
    ]);

    $user_country = $find_country->short_name ?? '';

    $enq = new Enquires();
    $enq->nama = $name;
    $enq->email = $email;
    $enq->whatsapp = $whatsapp;
    $enq->enquiry = $enquiry;
    $enq->save();

    require '../vendor/autoload.php';

    $inquiryData[] = [
        'name' => $name,
        'email' => $email,
        'whatsapp' => $whatsapp,
        'country' => $user_country,
        'enquiry' => $enquiry,
    ];

    $mailService = $this->di->get('mail');
    $result = $mailService->enquiryAction($inquiryData);

    return $this->response->setJsonContent([
        'status' => 'success',
        'message' => 'Enquiry sent'
    ]);
}


}

