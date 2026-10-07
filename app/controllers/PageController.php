<?php

class PageController extends ControllerBase
{

    public function indexAction()
    {
        $headerCollection = $this->assets->collection('header');
        $headerCollection->addCss('css/navbar.css');

    }

    public function detailAction(){
        $headerCollection = $this->assets->collection('header');
        $headerCollection->addCss('css/navbar.css');

        $page = $this->dispatcher->getParam('page_url');
        if($page == "about-us"){
            $title = "About Tropialis, Your Ultimate Travel & Experience Platform";
        }elseif($page == "faq"){
            $title = "Frequently Asked Questions";
        }
        $this->tag->setTitle($title);
        $this->view->pick('page/'.$page);
    }

    public function cookiesAction(){
        $this->tag->setTitle('Cookie Policy');
        $this->view->pick('page/cookies_policy');
    }

    public function enquiryAction(){
        $headerCollection = $this->assets->collection('header');
        $headerCollection->addCss('css/navbar.css');

        $footerCollection = $this->assets->collection('footer');
        $footerCollection->addJs('https://cdn.jsdelivr.net/npm/sweetalert2@11');
        $footerCollection->addJs('https://www.google.com/recaptcha/api.js');
        $footerCollection->addJs('js/enquiry.js');

         $q = "SELECT country_id, iso2, short_name FROM Countries ORDER BY short_name ASC";
        $countries = $this->modelsManager->executeQuery($q);
        $this->view->setVar('countries',$countries);
    }
}

