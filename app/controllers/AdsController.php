<?php

use Phalcon\Mvc\Controller;

class AdsController extends Controller
{
    public function adsAction()
    {
        // Path to ads.txt in the document root
        $filePath = $_SERVER['DOCUMENT_ROOT'] . '/ads.txt';
        
        // Check if the file exists
        if (file_exists($filePath)) {
            // Read and output the file content
            $content = file_get_contents($filePath);
            $this->response->setContentType('text/plain'); // Set appropriate MIME type for ads.txt
            $this->response->setContent($content);
            return $this->response;
        } else {
            // Handle error if file is missing (e.g., log or return 404)
            $this->response->setStatusCode(404, 'Not Found');
            $this->response->setContent('ads.txt not found.');
            return $this->response;
        }
    }
}