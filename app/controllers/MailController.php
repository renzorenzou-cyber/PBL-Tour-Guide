<?php

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\SMTP;
use PHPMailer\PHPMailer\Exception;

class MailController extends ControllerBase
{
    public function getExtras($id){
        $ge = "SELECT e.extra_name, eo.extra_info_value FROM Extras_infos_orderdetail eo LEFT JOIN Extras_infos e ON e.id = eo.id_extra WHERE eo.order_detail_id = '".$id."'";
        $extra = $this->modelsManager->executeQuery($ge);
        return $extra;
    }

    public function sendAction($orderDetails)
    {
        // echo "<pre>";
        // print_r($orderDetails);
        if (!empty($orderDetails)) {
            $productDetailsHtml = '';

            // Membuat variabel untuk menyimpan detail produk dalam format HTML
            foreach ($orderDetails as $orderDetail) {
                $module = $orderDetail['module'];
                $order_id = $orderDetail['id'];
                $item_id = $orderDetail['item_id'];
                $product = $orderDetail['product_name'];
                $cart_id = $orderDetail['cart_id'];
                $qty = $orderDetail['product_qty'];
                $currency = $orderDetail['selected_currency'];
                $price = $this->formatCurrency($orderDetail['product_price'], $currency);

                if ($module == '10') {
                    $tanggal = $orderDetail['tanggal'];
                    $timeselection = $orderDetail['timeselection'];
                    $productDetailsHtml .= "<br><div>[{$product}] {$currency} {$price} x {$qty}<br><strong>Date : {$tanggal}<br>Time : {$timeselection}</strong></div>";
                } elseif($module == '9') {
                    $tanggal = $orderDetail['tanggal'];
                    $days = $orderDetail['days'];
                    $productDetailsHtml .= "<br><div>[{$product}] {$currency} {$price} x {$qty}<br><strong>Date : {$tanggal}<br>Day(s) : {$days}</strong></div>";
                } elseif ($module == '1' || $module == '2') {
                    $checkin = $orderDetail['checkin'];
                    $checkout = $orderDetail['checkout'];
                    $productDetailsHtml .= "<br><div>[{$product}] {$currency} {$price} x {$qty}<br><strong>Checkin : {$checkin}<br>Checkout : {$checkout}</strong></div>";
                } elseif ($module == '11') {
                    $productDetailsHtml .= "<br><div>[{$product}] {$currency} {$price} x {$qty}</div>";
                }

                // Cek Addon dari session
                $hasAddon = false;

                foreach ($this->session->get('cart') as $cartItem) {
                    // Pastikan add-on hanya untuk produk yang sesuai
                    if (isset($cartItem['addons']) && isset($cartItem['item_id']) && isset($cartItem['cart_id']) && $cartItem['item_id'] == $orderDetail['item_id'] && $cartItem['cart_id'] == $orderDetail['cart_id']) {
                        $itemId = $cartItem['item_id']; // Mendapatkan item_id produk
                        $addons = $cartItem['addons']; // Mendapatkan add-on terkait dengan produk ini
                        
                        // Jika ada add-on, tampilkan
                        if (!empty($addons)) {
                            $hasAddon = true; // Menandakan ada add-on untuk produk ini
                            $productDetailsHtml .= "<div style='padding-top:5px'><strong>Add-ons:</strong><br><table cellpadding='4' style='margin-left:10px'>";

                            // Loop melalui add-on dan tampilkan setiap add-on
                            foreach ($addons as $addon) {
                                $addonName = htmlspecialchars($addon['name']); // Nama add-on
                                $addonQty = htmlspecialchars($addon['qty']);   // Jumlah add-on
                                $addonTotal = $this->formatCurrency($addon['total'], $currency); // Total harga add-on

                                // Tambahkan setiap add-on ke HTML
                                $productDetailsHtml .= "<tr><td>- {$addonName} x {$addonQty}</td><td style='text-align:right'>{$currency} {$addonTotal}</td></tr>";
                            }

                            // Tutup tabel untuk item ini
                            $productDetailsHtml .= "</table></div>";
                        }
                    }
                }

                // Cek Extras dari database
                $extras = $this->getExtras($order_id);
                if ($extras && count($extras) > 0) {
                    $productDetailsHtml .= "<div style='padding-top:10px'><strong>Extras:</strong><br><table cellpadding='4' style='margin-left:10px'>";
                    foreach ($extras as $extra) {
                        $extraName = htmlspecialchars($extra['extra_name']);
                        $extraValue = htmlspecialchars($extra['extra_info_value']);
                        $productDetailsHtml .= "<tr><td>{$extraName}</td><td>:</td><td>{$extraValue}</td></tr>";
                    }
                    $productDetailsHtml .= "</table></div>";
                }
                $total = $this->formatCurrency($orderDetail['total'], $currency);
                $orderCode= ($orderDetail['orderCode']);
                $phone = $orderDetail['phone'];
                $country = ($orderDetail['country']);
                $name =($orderDetail['name']);
                $email = $orderDetail['email'];
                $link_payment = $orderDetail['link_payment'];
            }
            $logoUrl = 'https://www.tropialis.com/img/logo.png';
        //     echo $productDetailsHtml;
        // die('test');
        // Create an instance of PHPMailer
        $mail = new PHPMailer(true);

        try {
            // // Debugging (Opsional, untuk memeriksa log error)
            // var_dump($this->config->mailer);
        
            // Ambil Konfigurasi SMTP dari config.ini
            $mail->isSMTP();
            $mail->Host       = 'smtp.gmail.com';  
            $mail->SMTPAuth   = filter_var($this->config->mailer->SMTPAuth, FILTER_VALIDATE_BOOLEAN); // SMTP Authentication
            $mail->Username   = $this->config->mailer->username;    // Username dari config.ini
            $mail->Password   = $this->config->mailer->password;    // Password dari config.ini
            $mail->SMTPSecure = PHPMailer::ENCRYPTION_SMTPS;  
            $mail->Port       = 465;       
        
            // Konfigurasi Email
            $mail->setFrom($this->config->mailer->username, $this->config->mailer->sender_name);
            $mail->addAddress($email, $name); // Penerima
            $mail->addBCC('tropialisexoticparadise@gmail.com');
        
            // Konten Email
            $mail->isHTML(true); 
            $mail->Subject = 'Order '.$orderCode.', '.$name.', '.$country;
            $recipientName = $email;
            $mail->Body = '
            <!DOCTYPE html>
            <html lang="en">
            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <style>
                    body {
                        font-family: Arial, sans-serif;
                        background-color: #f4f7fc;
                        color: #333;
                        margin: 0;
                        padding: 0;
                        line-height: 1.6;
                    }
                    .email-container {
                        width: 100%;
                        max-width: 600px;
                        margin: 0 auto;
                        background-color: #ffffff;
                        border-radius: 8px;
                        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                        overflow: hidden;
                    }
                    .content {
                        padding: 20px;
                    }
                    .content h2 {
                        color: #333333;
                        font-size: 22px;
                        margin-bottom: 20px;
                    }
                    .content p {
                        font-size: 16px;
                        color: #555555;
                        margin-bottom: 10px;
                    }
                    .reservation-details {
                        margin-top: 20px;
                    }
                    .reservation-details .detail {
                        display: flex;
                        justify-content: space-between;
                        margin-bottom: 8px;
                    }
                    .reservation-details .detail span {
                        min-width: 150px;
                        text-align: left;
                    }
                    .reservation-details .detail strong {
                        text-align: right;
                    }
                    .total-section {
                        margin-top: 20px;
                        text-align: left;
                    }
                    .total-section .total-label {
                        font-size: 18px;
                        font-weight: bold;
                    }
                    .total-section .total-price {
                        font-size: 24px;
                        font-weight: bold;
                    }
                    .footer {
                        background-color: #f1f1f1;
                        padding: 15px;
                        font-size: 14px;
                        color: #888888;
                    }
                    .footer p {
                        margin: 5px 0;
                    }
                    .button {
                        display: inline-block;
                        background-color: #4CAF50;
                        color: #ffffff;
                        padding: 12px 25px;
                        font-size: 16px;
                        text-decoration: none;
                        border-radius: 5px;
                        margin-top: 20px;
                        text-transform: uppercase;
                    }
                    .button:hover {
                        background-color: #45a049;
                    }
                    
                    .payment-button {
                    display: inline-block;
                    background-color: #007bff; /* Warna biru */
                    color: white;
                    padding: 10px 20px;
                    text-decoration: none;
                    font-weight: bold;
                    border-radius: 5px;
                    box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.2);
                    border: none;
                    transition: background-color 0.3s ease;
                }

                .payment-button:hover {
                    background-color: #0056b3; /* Warna biru lebih gelap saat hover */
                }
                </style>
            </head>
            <body>
                <div class="email-container">
                    <div class="content">
                        <h2>Hello!</h2>
                        <p>Thank you for your order! We have put together a little summary of your order for you right here.</p>
                        
                        <!-- Reservation Details with aligned colons -->
                        <div class="reservation-details">
                            <div class="detail">
                                <span><strong>Order Number</strong></span>
                                <span>: '.$orderCode.'</span>
                            </div>
                            <div class="detail">
                                <span><strong>Name</strong></span>
                                <span>: '.$name.'</span>
                            </div>
                            <div class="detail">
                                <span><strong>Phone</strong></span>
                                <span>: +'.$phone.'</span>
                            </div>
                            <div class="detail">
                                <span><strong>Country</strong></span>
                                <span>: '.$country.'</span>
                            </div>
                            <div class="detail" style="padding-top:40px;">
                                <span><strong>Order Detail:</strong></span>
                            </div>
                            <div>
                                '.$productDetailsHtml.'
                            </div>
                        </div>

                        <!-- Total Section -->
                        <div class="total-section">
                            <div class="total-label">TOTAL</div>
                            <div>'.$currency.' '.$total.'</div>
                        </div>

                        <div style="padding-top:30px;">
                            <p>Please make the payment through this link below:</p>
                            <p><a href="'.$link_payment.'" target="_blank" class="payment-button">Payment Link</a></p>
                            <p>If it is not works, please copy this url and paste it to your browser : '.$link_payment.'</p><p><strong>Note: Please ignore the payment link if you have already made the payment.</strong></p>
                        </div>
                        <div class="detail " style="margin-bottom:1rem;">
                            <span>Need help? Our support team is ready to assist you at tropialisexoticparadise@gmail.com</span>
                        </div>
                        <p>Best Regards, </p>
                        <p>Tropialis Team</p>
                    </div>
                    <div class="footer" style="padding: 15px; font-size: 14px; color: #333; background-color: #ffffff; border-radius: 8px; overflow: hidden; width: fit-content; max-width: 100%;">
                        <div style="background-color: #87CEEB; padding: 20px; border-radius: 12px; display: flex; justify-content: center; align-items: center; width: auto;">
                            <img class="img-fluid" style="max-width: 120px; height: auto;" src="'.$logoUrl.'" alt="Logo">
                        </div>
                        <p style="margin-top: 10px; font-size: 13px;">
                            Tropialis.com - PT. Tropialis Karya Nusantara, Jl. Srikandi 50, Nusa Dua, Benoa, Kuta Selatan, Badung, Bali, Indonesia 80361
                        </p>
                        <p>
                            <a href="https://www.tropialis.com/page/about-us/" target="_blank" style="color:black; text-decoration: none;">About Us</a> | 
                            <a href="https://www.tropialis.com/page/faq/" target="_blank" style="color:black; text-decoration: none;">FAQ</a> | 
                            <a href="https://wa.me/62881037336399" target="_blank" style="color:black; text-decoration: none;">Contact Us</a>
                        </p>
                    </div>

                </div>
            </body>
            </html>
            ';



        
            // Kirim Email
            $mail->send();
        } catch (Exception $e) {
            echo "Mailer Error: " . $mail->ErrorInfo;
        }
        }
}


    public function signupAction($signupActivation)
{
            if (!empty($signupActivation)) {
                // Membuat variabel untuk menyimpan detail produk dalam format HTML
                foreach ($signupActivation as $signupActivations) {
                    $name = htmlspecialchars($signupActivations['name']);
                    $email = htmlspecialchars($signupActivations['email']);
                    $activation_link = htmlspecialchars($signupActivations['activation_link']);
                }
        
                $logoUrl = 'https://www.tropialis.com/img/logo.png';
            // Create an instance of PHPMailer
            $mail = new PHPMailer(true);

            try {
                // // Debugging (Opsional, untuk memeriksa log error)
                // var_dump($this->config->mailer);
            
                // Ambil Konfigurasi SMTP dari config.ini
                $mail->isSMTP();
                $mail->Host       = 'smtp.gmail.com';  
                $mail->SMTPAuth   = filter_var($this->config->mailer->SMTPAuth, FILTER_VALIDATE_BOOLEAN); // SMTP Authentication
                $mail->Username   = $this->config->mailer->username;    // Username dari config.ini
                $mail->Password   = $this->config->mailer->password;    // Password dari config.ini
                $mail->SMTPSecure = PHPMailer::ENCRYPTION_SMTPS;  
                $mail->Port       = 465;       
            
                // Konfigurasi Email
                $mail->setFrom($this->config->mailer->username, $this->config->mailer->sender_name);
                $mail->addAddress($email, $name); // Penerima
                $mail->addBCC('tropialisexoticparadise@gmail.com');
            
                // Konten Email
                $mail->isHTML(true); 
                $mail->Subject = 'Welcome to  Tropialis - Your Journey Begins here!';
                $recipientName = $email;
                $mail->Body = '
                <!DOCTYPE html>
                <html lang="en">
                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <style>
                        body {
                            font-family: Arial, sans-serif;
                            background-color: #f4f7fc;
                            color: #333;
                            margin: 0;
                            padding: 0;
                            line-height: 1.6;
                        }
                        .email-container {
                            width: 100%;
                            max-width: 600px;
                            margin: 0 auto;
                            background-color: #ffffff;
                            border-radius: 8px;
                            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                            overflow: hidden;
                        }
                        .content {
                            padding: 20px;
                        }
                        .content h2 {
                            color: #333333;
                            font-size: 22px;
                            margin-bottom: 20px;
                        }
                        .content p {
                            font-size: 16px;
                            color: #555555;
                            margin-bottom: 10px;
                        }
                        .reservation-details {
                            margin-top: 20px;
                        }
                        .reservation-details .detail {
                            display: flex;
                            justify-content: space-between;
                            margin-bottom: 8px;
                        }
                        .reservation-details .detail span {
                            min-width: 150px;
                            text-align: left;
                        }
                        .reservation-details .detail strong {
                            text-align: right;
                        }
                        .total-section {
                            margin-top: 20px;
                            text-align: left;
                        }
                        .total-section .total-label {
                            font-size: 18px;
                            font-weight: bold;
                        }
                        .total-section .total-price {
                            font-size: 24px;
                            font-weight: bold;
                        }
                        .footer {
                        background-color: #f1f1f1;
                        padding: 15px;
                        font-size: 14px;
                        color: #888888;
                    }
                    .footer p {
                        margin: 5px 0;
                    }
                        .button {
                            display: inline-block;
                            background-color: #4CAF50;
                            color: #ffffff;
                            padding: 12px 25px;
                            font-size: 16px;
                            text-decoration: none;
                            border-radius: 5px;
                            margin-top: 20px;
                            text-transform: uppercase;
                        }
                        .button:hover {
                            background-color: #45a049;
                        }
                    </style>
                </head>
                <body>
                    <div class="email-container">
                        <div class="content">
                            <h2>Dear '.$name.'</h2>
                            <p>Welcome to Tropialis! We are excited to have you on board as part of our travel community. Your new account is now registered. Please activate your account by click the link below: </p>
                            
                            <!-- Reservation Details with aligned colons -->
                            <div class="reservation-details">
                                <div>
                                    <p> '.$activation_link.'</p>
                                </div>
                                <div class="detail">
                                    <span>if you cant click it, please copy and paste it into your browser</span>
                                </div>
                                <div class="detail">
                                    <span>Your registered email : '.$email.'</span>
                                </div>
                                <div class="detail " style="margin-bottom:1rem;">
                                    <span>Need help? Our support team is ready to assist you at tropialisexoticparadise@gmail.com</span>
                                </div>

                            <p>Warm Regards, </p>
                            <p>The Tropialis Team</p>
                        </div>
                        <div class="footer" style="padding: 15px; font-size: 14px; color: #333; background-color: #ffffff; border-radius: 8px; overflow: hidden; width: fit-content; max-width: 100%;">
                        <div style="background-color: #87CEEB; padding: 20px; border-radius: 12px; display: flex; justify-content: center; align-items: center; width: auto;">
                            <img class="img-fluid" style="max-width: 120px; height: auto;" src="'.$logoUrl.'" alt="Logo">
                        </div>
                        <p style="margin-top: 10px; font-size: 13px;">
                            Tropialis.com - PT. Tropialis Karya Nusantara, Jl. Srikandi 50, Nusa Dua, Benoa, Kuta Selatan, Badung, Bali, Indonesia 80361
                        </p>
                        <p>
                            <a href="https://www.tropialis.com/page/about-us/" target="_blank" style="color:black; text-decoration: none;">About Us</a> | 
                            <a href="https://www.tropialis.com/page/faq/" target="_blank" style="color:black; text-decoration: none;">FAQ</a> | 
                            <a href="https://wa.me/62881037336399" target="_blank" style="color:black; text-decoration: none;">Contact Us</a>
                        </p>
                    </div>
                    </div>
                </body>
                </html>
                ';
                // Kirim Email
                $mail->send();
            } catch (Exception $e) {
                echo "Mailer Error: " . $mail->ErrorInfo;
            }
        }
}

    public function forgetpasswordAction($forgetpassword){
        if (!empty($forgetpassword)) {
            // Membuat variabel untuk menyimpan detail produk dalam format HTML
            foreach ($forgetpassword as $forgetpasswords) {
                $resetpassword = htmlspecialchars($forgetpasswords['resetpassword']);
                $name = htmlspecialchars($forgetpasswords['name']);
                $email = htmlspecialchars($forgetpasswords['email']);
            }
    
            $logoUrl = 'https://www.tropialis.com/img/logo.png';
        // Create an instance of PHPMailer
        $mail = new PHPMailer(true);

        try {
            // // Debugging (Opsional, untuk memeriksa log error)
            // var_dump($this->config->mailer);
        
            // Ambil Konfigurasi SMTP dari config.ini
            $mail->isSMTP();
            $mail->Host       = 'smtp.gmail.com';  
            $mail->SMTPAuth   = filter_var($this->config->mailer->SMTPAuth, FILTER_VALIDATE_BOOLEAN); // SMTP Authentication
            $mail->Username   = $this->config->mailer->username;    // Username dari config.ini
            $mail->Password   = $this->config->mailer->password;    // Password dari config.ini
            $mail->SMTPSecure = PHPMailer::ENCRYPTION_SMTPS;  
            $mail->Port       = 465;       
        
            // Konfigurasi Email
            $mail->setFrom($this->config->mailer->username, $this->config->mailer->sender_name);
            $mail->addAddress($email, $name); // Penerima
            $mail->addBCC('tropialisexoticparadise@gmail.com');
        
            // Konten Email
            $mail->isHTML(true); 
            $mail->Subject = 'Reset Your Password - Tropialis';
            $recipientName = $name;
            $mail->Body = '
            <!DOCTYPE html>
            <html lang="en">
            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <style>
                    body {
                        font-family: Arial, sans-serif;
                        background-color: #f4f7fc;
                        color: #333;
                        margin: 0;
                        padding: 0;
                        line-height: 1.6;
                    }
                    .email-container {
                        width: 100%;
                        max-width: 600px;
                        margin: 0 auto;
                        background-color: #ffffff;
                        border-radius: 8px;
                        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                        overflow: hidden;
                    }
                    .content {
                        padding: 20px;
                    }
                    .content h2 {
                        color: #333333;
                        font-size: 22px;
                        margin-bottom: 20px;
                    }
                    .content p {
                        font-size: 16px;
                        color: #555555;
                        margin-bottom: 10px;
                    }
                    .reservation-details {
                        margin-top: 20px;
                    }
                    .reservation-details .detail {
                        display: flex;
                        justify-content: space-between;
                        margin-bottom: 8px;
                    }
                    .reservation-details .detail span {
                        min-width: 150px;
                        text-align: left;
                    }
                    .reservation-details .detail strong {
                        text-align: right;
                    }
                    .total-section {
                        margin-top: 20px;
                        text-align: left;
                    }
                    .total-section .total-label {
                        font-size: 18px;
                        font-weight: bold;
                    }
                    .total-section .total-price {
                        font-size: 24px;
                        font-weight: bold;
                    }
                    .footer {
            background-color: #f1f1f1;
            padding: 15px;
            font-size: 14px;
            color: #888888;
        }
        .footer p {
            margin: 5px 0;
        }
                    .button {
                        display: inline-block;
                        background-color: #4CAF50;
                        color: #ffffff;
                        padding: 12px 25px;
                        font-size: 16px;
                        text-decoration: none;
                        border-radius: 5px;
                        margin-top: 20px;
                        text-transform: uppercase;
                    }
                    .button:hover {
                        background-color: #45a049;
                    }
                </style>
            </head>
            <body>
                <div class="email-container">
                    <div class="content">
                        <h2>Dear '.$name.'</h2>
                        <p>We received a request to reset your password for your tropialis account. if you initiated this request, you can reset your password by clicking the button below: </p>
                        
                        <!-- Reservation Details with aligned colons -->
                        <div class="reservation-details">
                            <div>
                                <p><a href="'.$resetpassword.'" target="_blank">'.$resetpassword.'</a></p>
                            </div>
                            <div class="mb-2" style="">
                                <p>if the button does not work, you can also copy and paste this link into your browser:</p>
                                <p><a style="font-size: 14px; color: inherit; text-decoration: none;">'.$resetpassword.'</a></p>
                            </div>
                            <div class="detail" style="margin-bottom:1rem;">
                                <span>this link is valid for the next 24 hours. for security purposes, the link will expire after this time.</span>
                            </div>
                            <div class="detail " style="margin-bottom:1rem;">
                                <span>if you did not request a password reset, no action is needed. Your account is secure, but we recomended reviewing your account details for added security</span>
                            </div>
                            <div class="detail " style="margin-bottom:1rem;">
                                <span>Need help? Our support team is ready to assist you at tropialisexoticparadise@gmail.com</span>
                            </div>
                            <div class="detail" style="margin-bottom:1rem;">
                                <span>Stay Connected!</span>
                            </div>
                            <div class="detail" style="margin-bottom:1rem;">
                                <span>Thank you for choosing Tropialis for your travel adventures</span>
                            </div>

                        <p>Warm Regards, </p>
                        <p>The Tropialis Team</p>
                    </div>
                    <div class="footer" style="padding: 15px; font-size: 14px; color: #333; background-color: #ffffff; border-radius: 8px; overflow: hidden; width: fit-content; max-width: 100%;">
            <div style="background-color: #87CEEB; padding: 20px; border-radius: 12px; display: flex; justify-content: center; align-items: center; width: auto;">
                <img class="img-fluid" style="max-width: 120px; height: auto;" src="'.$logoUrl.'" alt="Logo">
            </div>
            <p style="margin-top: 10px; font-size: 13px;">
                Tropialis.com - PT. Tropialis Karya Nusantara, Jl. Srikandi 50, Nusa Dua, Benoa, Kuta Selatan, Badung, Bali, Indonesia 80361
            </p>
            <p>
                <a href="https://www.tropialis.com/page/about-us/" target="_blank" style="color:black; text-decoration: none;">About Us</a> | 
                <a href="https://www.tropialis.com/page/faq/" target="_blank" style="color:black; text-decoration: none;">FAQ</a> | 
                <a href="https://wa.me/62881037336399" target="_blank" style="color:black; text-decoration: none;">Contact Us</a>
            </p>
        </div>
                </div>
            </body>
            </html>
            ';
                        // Kirim Email
                        $mail->send();
                    } catch (Exception $e) {
                        echo "Mailer Error: " . $mail->ErrorInfo;
                    }
                }
    }

    public function createAccountAction($createAccount)
{
            if (!empty($createAccount)) {
                // Membuat variabel untuk menyimpan detail produk dalam format HTML
                foreach ($createAccount as $createAccounts) {
                    $name = htmlspecialchars($createAccounts['name']);
                    $email = htmlspecialchars($createAccounts['email']);
                    $password = htmlspecialchars($createAccounts['password']);
                    $login_link = htmlspecialchars($createAccounts['login_link']);
                }
        
                $logoUrl = 'https://www.tropialis.com/img/logo.png';

            // Create an instance of PHPMailer
            $mail = new PHPMailer(true);

            try {
                // // Debugging (Opsional, untuk memeriksa log error)
                // var_dump($this->config->mailer);
            
                // Ambil Konfigurasi SMTP dari config.ini
                $mail->isSMTP();
                $mail->Host       = 'smtp.gmail.com';  
                $mail->SMTPAuth   = filter_var($this->config->mailer->SMTPAuth, FILTER_VALIDATE_BOOLEAN); // SMTP Authentication
                $mail->Username   = $this->config->mailer->username;    // Username dari config.ini
                $mail->Password   = $this->config->mailer->password;    // Password dari config.ini
                $mail->SMTPSecure = PHPMailer::ENCRYPTION_SMTPS;  
                $mail->Port       = 465;       
            
                // Konfigurasi Email
                $mail->setFrom($this->config->mailer->username, $this->config->mailer->sender_name);
                $mail->addAddress($email, $name); // Penerima
                $mail->addBCC('tropialisexoticparadise@gmail.com');
            
                // Konten Email
                $mail->isHTML(true); 
                $mail->Subject = $name.' Your Account is Now Active - Welcome to Tropialis!';
                $recipientName = $email;
                $mail->Body = '
                <!DOCTYPE html>
                <html lang="en">
                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <style>
                        body {
                            font-family: Arial, sans-serif;
                            background-color: #f4f7fc;
                            color: #333;
                            margin: 0;
                            padding: 0;
                            line-height: 1.6;
                        }
                        .email-container {
                            width: 100%;
                            max-width: 600px;
                            margin: 0 auto;
                            background-color: #ffffff;
                            border-radius: 8px;
                            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                            overflow: hidden;
                        }
                        .content {
                            padding: 20px;
                        }
                        .content h2 {
                            color: #333333;
                            font-size: 22px;
                            margin-bottom: 20px;
                        }
                        .content p {
                            font-size: 16px;
                            color: #555555;
                            margin-bottom: 10px;
                        }
                        .reservation-details {
                            margin-top: 20px;
                        }
                        .reservation-details .detail {
                            display: flex;
                            justify-content: space-between;
                            margin-bottom: 8px;
                        }
                        .reservation-details .detail span {
                            min-width: 150px;
                            text-align: left;
                        }
                        .reservation-details .detail strong {
                            text-align: right;
                        }
                        .total-section {
                            margin-top: 20px;
                            text-align: left;
                        }
                        .total-section .total-label {
                            font-size: 18px;
                            font-weight: bold;
                        }
                        .total-section .total-price {
                            font-size: 24px;
                            font-weight: bold;
                        }
                        .footer {
                            background-color: #f1f1f1;
                            padding: 15px;
                            font-size: 14px;
                            color: #888888;
                        }
                        .footer p {
                            margin: 5px 0;
                        }
                        .button {
                            display: inline-block;
                            background-color: #4CAF50;
                            color: #ffffff;
                            padding: 12px 25px;
                            font-size: 16px;
                            text-decoration: none;
                            border-radius: 5px;
                            margin-top: 20px;
                            text-transform: uppercase;
                        }
                        .button:hover {
                            background-color: #45a049;
                        }
                    </style>
                </head>
                <body>
                    <div class="email-container">
                        <div class="content">
                            <h2>Hello '.$name.'</h2>
                            <p>Welcome to Tropialis! We have automatically created an account for you, so you can start shopping and enjoying our services right away.</p>
                            
                            <!-- Reservation Details with aligned colons -->
                            <div class="reservation-details">
                                <div class="detail" style="padding-top:40px;">
                                    <span><strong>your account :</strong></span>
                                </div>
                                <div class="detail">
                                    <span><strong>Email</strong></span>
                                    <span>: '.$email.'</span>
                                </div>
                                <div class="detail">
                                    <span><strong>Password</strong></span>
                                    <span>: '.$password.'</span>
                                </div>
                            </div>

                            <div style="padding-top:30px;">
                                <p>For security reasons, we recommend that you change your password after Log-in in for the first time.</p>
                                <p>You can log in now using the link below:</p>
                                <p><a href="'.$login_link.'" target="_blank" class="btn btn-success">Login</a></p>
                                <p>If it is not works, please copy this url and paste it to your browser : '.$login_link.'</p>
                            </div>
                            <div class="detail " style="margin-bottom:1rem;">
                                <span>Need help? Our support team is ready to assist you at tropialisexoticparadise@gmail.com</span>
                            </div>
                            <p>Best Regards, </p>
                            <p>Tropialis Team</p>
                        </div>
                        <div class="footer" style="padding: 15px; font-size: 14px; color: #333; background-color: #ffffff; border-radius: 8px; overflow: hidden; width: fit-content; max-width: 100%;">
                            <div style="background-color: #87CEEB; padding: 20px; border-radius: 12px; display: flex; justify-content: center; align-items: center; width: auto;">
                                <img class="img-fluid" style="max-width: 120px; height: auto;" src="'.$logoUrl.'" alt="Logo">
                            </div>
                            <p style="margin-top: 10px; font-size: 13px;">
                                Tropialis.com - PT. Tropialis Karya Nusantara, Jl. Srikandi 50, Nusa Dua, Benoa, Kuta Selatan, Badung, Bali, Indonesia 80361
                            </p>
                            <p>
                                <a href="https://www.tropialis.com/page/about-us/" target="_blank" style="color:black; text-decoration: none;">About Us</a> | 
                                <a href="https://www.tropialis.com/page/faq/" target="_blank" style="color:black; text-decoration: none;">FAQ</a> | 
                                <a href="https://wa.me/62881037336399" target="_blank" style="color:black; text-decoration: none;">Contact Us</a>
                            </p>
                        </div>
                    </div>
                </body>
                </html>
                    ';
                // Kirim Email
                $mail->send();
            } catch (Exception $e) {
                echo "Mailer Error: " . $mail->ErrorInfo;
            }
        }
}

    public function cancelOrderAction($CancelDetail){
        if (!empty($CancelDetail)) {
            $productDetailsHtml = '';

            // Membuat variabel untuk menyimpan detail produk dalam format HTML
            foreach ($CancelDetail as $CancelDetails) {
                $module = $CancelDetails['module'];
                $order_id = $CancelDetails['id'];
                $product = $CancelDetails['product_name'];
                $qty = (int)$CancelDetails['product_qty'];
                $currency = $CancelDetails['selected_currency'];
                $price = $this->formatCurrency($CancelDetails['product_price'], $currency);

                if ($module == '10') {
                    $tanggal = $CancelDetails['tanggal'];
                    $timeselection = (new DateTime($CancelDetails['timeselection']))->format('H:i');
                    $productDetailsHtml .= "<br><div>[{$product}] {$currency} {$price} x {$qty}<br><strong>Date : {$tanggal}<br>Time : {$timeselection}</strong></div>";
                } elseif($module == '9') {
                    $tanggal = $CancelDetails['tanggal'];
                    $days = $CancelDetails['days'];
                    $productDetailsHtml .= "<br><div>[{$product}] {$currency} {$price} x {$qty}<br><strong>Date : {$tanggal}<br>Day(s) : {$days}</strong></div>";
                } elseif ($module == '1') {
                    $order_date = $CancelDetails['tanggal'];
                    $order_days = (int)$CancelDetails['days'];

                    $checkin = $order_date;

                    $checkoutDate = new DateTime($order_date);
                    $checkoutDate->modify("+{$order_days} days");
                    $checkout = $checkoutDate->format('Y-m-d');
                    $productDetailsHtml .= "<br><div>[{$product}] {$currency} {$price} x {$qty}<br><strong>Checkin : {$checkin}<br>Checkout : {$checkout}</strong></div>";
                }

                $total = $this->formatCurrency($CancelDetails['total'], $currency);
                $orderCode= ($CancelDetails['orderCode']);
                $phone = $CancelDetails['phone'];
                $country = ($CancelDetails['country']);
                $name =($CancelDetails['name']);
                $email = $CancelDetails['email'];
                $cancel_reason = $CancelDetails['reason'];
            }
            $logoUrl = 'https://www.tropialis.com/img/logo.png';
        //     echo $productDetailsHtml;
        // die('test');
        // Create an instance of PHPMailer
        $mail = new PHPMailer(true);

        try {
            // // Debugging (Opsional, untuk memeriksa log error)
            // var_dump($this->config->mailer);
        
            // Ambil Konfigurasi SMTP dari config.ini
            $mail->isSMTP();
            $mail->Host       = 'smtp.gmail.com';  
            $mail->SMTPAuth   = filter_var($this->config->mailer->SMTPAuth, FILTER_VALIDATE_BOOLEAN); // SMTP Authentication
            $mail->Username   = $this->config->mailer->username;    // Username dari config.ini
            $mail->Password   = $this->config->mailer->password;    // Password dari config.ini
            $mail->SMTPSecure = PHPMailer::ENCRYPTION_SMTPS;  
            $mail->Port       = 465;       
        
            // Konfigurasi Email
            $mail->setFrom($this->config->mailer->username, $this->config->mailer->sender_name);
            $mail->addAddress($email, $name); // Penerima
            $mail->addBCC('tropialisexoticparadise@gmail.com');
        
            // Konten Email
            $mail->isHTML(true); 
            $mail->Subject = 'Order Cancellation - '.$orderCode.', '.$name.', '.$country;
            $recipientName = $email;
            $mail->Body = '
            <!DOCTYPE html>
            <html lang="en">
            <head>
                <meta charset="UTF-8">
                <style>
                    body {
                        font-family: Arial, sans-serif;
                        background-color: #f4f7fc;
                        color: #333;
                        margin: 0;
                        padding: 0;
                        line-height: 1.6;
                    }
                    .email-container {
                        width: 100%;
                        max-width: 600px;
                        margin: 0 auto;
                        background-color: #ffffff;
                        border-radius: 8px;
                        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                        overflow: hidden;
                    }
                    .content {
                        padding: 20px;
                    }
                    .content h2 {
                        font-size: 22px;
                        margin-bottom: 20px;
                    }
                    .content p {
                        font-size: 16px;
                        color: #555555;
                        margin-bottom: 10px;
                    }
                    .reservation-details {
                        margin-top: 20px;
                    }
                    .reservation-details .detail {
                        display: flex;
                        justify-content: space-between;
                        margin-bottom: 8px;
                    }
                    .reservation-details .detail span {
                        min-width: 150px;
                        text-align: left;
                    }
                    .reservation-details .detail strong {
                        text-align: right;
                    }
                    .footer {
                        padding: 15px;
                        font-size: 14px;
                        color: #888888;
                    }
                    .footer p {
                        margin: 5px 0;
                    }
                    .footer a {
                        color: black;
                        text-decoration: none;
                    }
                </style>
            </head>
            <body>
                <div class="email-container">
                    <div class="content">
                        <h2>Your Order Has Been Cancelled</h2>
                        <p>Hello '.$name.',</p>
                        <p>We regret to inform you that your order has been cancelled. Please find the details below:</p>

                        <div class="reservation-details">
                            <div class="detail">
                                <span><strong>Order Number</strong></span>
                                <span>: '.$orderCode.'</span>
                            </div>
                            <div class="detail">
                                <span><strong>Name</strong></span>
                                <span>: '.$name.'</span>
                            </div>
                            <div class="detail">
                                <span><strong>Phone</strong></span>
                                <span>: '.$phone.'</span>
                            </div>
                            <div class="detail">
                                <span><strong>Country</strong></span>
                                <span>: '.$country.'</span>
                            </div>
                            <div class="detail" style="padding-top:30px;">
                                <span><strong>Order Detail:</strong></span>
                            </div>
                            <div>'.$productDetailsHtml.'</div>
                        </div>

                        <div class="total-section" style="margin-top:20px;">
                            <div><strong>Total:</strong> '.$currency.' '.$total.'</div>
                        </div>

                        <div style="margin-top:30px;">
                            <p><strong>Reason for cancellation:</strong></p>
                            <p>'.$cancel_reason.'</p>
                        </div>

                        <p>If you think this cancellation was made in error or would like to reorder, please contact our support team.</p>
                        <div style="margin-top:30px; margin-bottom:20px;">
                            <p>Need help? Our support team is ready to assist you at <strong>tropialisexoticparadise@gmail.com</strong></p>
                            <p>Best regards,<br>The Tropialis Team</p>
                        </div>
                    </div>

                    <div class="footer" style="padding: 15px; font-size: 14px; color: #333; background-color: #ffffff; border-radius: 8px; overflow: hidden; width: fit-content; max-width: 100%;">
                        <div style="background-color: #87CEEB; padding: 20px; border-radius: 12px; display: flex; justify-content: center; align-items: center; width: auto;">
                            <img class="img-fluid" style="max-width: 120px; height: auto;" src="'.$logoUrl.'" alt="Logo">
                        </div>
                        <p style="margin-top: 10px; font-size: 13px;">
                            Tropialis.com - PT. Tropialis Karya Nusantara, Jl. Srikandi 50, Nusa Dua, Benoa, Kuta Selatan, Badung, Bali, Indonesia 80361
                        </p>
                        <p>
                            <a href="https://www.tropialis.com/page/about-us/" target="_blank" style="color:black; text-decoration: none;">About Us</a> | 
                            <a href="https://www.tropialis.com/page/faq/" target="_blank" style="color:black; text-decoration: none;">FAQ</a> | 
                            <a href="https://wa.me/62881037336399" target="_blank" style="color:black; text-decoration: none;">Contact Us</a>
                        </p>
                    </div>
                </div>
            </body>
            </html>
            ';



        
            // Kirim Email
            $mail->send();
        } catch (Exception $e) {
            echo "Mailer Error: " . $mail->ErrorInfo;
        }
        }
    }

    public function enquiryAction($inquiryData)
{
            if (!empty($inquiryData)) {
                // Membuat variabel untuk menyimpan detail produk dalam format HTML
                foreach ($inquiryData as $inquiryDatas) {
                    $name = htmlspecialchars($inquiryDatas['name']);
                    $email = htmlspecialchars($inquiryDatas['email']);
                    $whatsapp = htmlspecialchars($inquiryDatas['whatsapp']);
                    $country = htmlspecialchars($inquiryDatas['country']);
                    $enquiry = htmlspecialchars($inquiryDatas['enquiry']);
                }
        
                $logoUrl = 'https://www.tropialis.com/img/logo.png';

            // Create an instance of PHPMailer
            $mail = new PHPMailer(true);

            try {
                // // Debugging (Opsional, untuk memeriksa log error)
                // var_dump($this->config->mailer);
            
                // Ambil Konfigurasi SMTP dari config.ini
                $mail->isSMTP();
                $mail->Host       = 'smtp.gmail.com';  
                $mail->SMTPAuth   = filter_var($this->config->mailer->SMTPAuth, FILTER_VALIDATE_BOOLEAN); // SMTP Authentication
                $mail->Username   = $this->config->mailer->username;    // Username dari config.ini
                $mail->Password   = $this->config->mailer->password;    // Password dari config.ini
                $mail->SMTPSecure = PHPMailer::ENCRYPTION_SMTPS;  
                $mail->Port       = 465;       
            
                // Konfigurasi Email
                $mail->setFrom($this->config->mailer->username, $this->config->mailer->sender_name);
                $mail->addAddress($email, $name); // Penerima
                $mail->addBCC('tropialisexoticparadise@gmail.com');
            
                // Konten Email
                $mail->isHTML(true); 
                $mail->Subject = 'Thank You for Your Enquiry - Tropialis!';
                $recipientName = $email;
                $mail->Body = '
                <!DOCTYPE html>
                <html lang="en">
                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <style>
                        body {
                            font-family: Arial, sans-serif;
                            background-color: #f4f7fc;
                            color: #333;
                            margin: 0;
                            padding: 0;
                            line-height: 1.6;
                        }
                        .email-container {
                            width: 100%;
                            max-width: 600px;
                            margin: 0 auto;
                            background-color: #ffffff;
                            border-radius: 8px;
                            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                            overflow: hidden;
                        }
                        .content {
                            padding: 20px;
                        }
                        .content h2 {
                            color: #333333;
                            font-size: 22px;
                            margin-bottom: 20px;
                        }
                        .content p {
                            font-size: 16px;
                            color: #555555;
                            margin-bottom: 10px;
                        }
                        .reservation-details {
                            margin-top: 20px;
                        }
                        .reservation-details .detail {
                            display: flex;
                            justify-content: space-between;
                            margin-bottom: 8px;
                        }
                        .reservation-details .detail span {
                            min-width: 150px;
                            text-align: left;
                        }
                        .reservation-details .detail strong {
                            text-align: right;
                        }
                        .total-section {
                            margin-top: 20px;
                            text-align: left;
                        }
                        .total-section .total-label {
                            font-size: 18px;
                            font-weight: bold;
                        }
                        .total-section .total-price {
                            font-size: 24px;
                            font-weight: bold;
                        }
                        .footer {
                            background-color: #f1f1f1;
                            padding: 15px;
                            font-size: 14px;
                            color: #888888;
                        }
                        .footer p {
                            margin: 5px 0;
                        }
                        .button {
                            display: inline-block;
                            background-color: #4CAF50;
                            color: #ffffff;
                            padding: 12px 25px;
                            font-size: 16px;
                            text-decoration: none;
                            border-radius: 5px;
                            margin-top: 20px;
                            text-transform: uppercase;
                        }
                        .button:hover {
                            background-color: #45a049;
                        }
                    </style>
                </head>
                <body>
                    <div class="email-container">
                        <div class="content">
                            <p>Thank You for Your Enquiry</p>
                            <h2>Hello '.$name.'</h2>
                            <p>We have received your enquiry and our team will get back to you shortly.</p>
                            
                            <!-- Reservation Details with aligned colons -->
                            <div class="reservation-details">
                                <div class="detail" style="padding-top:40px;">
                                    <span><strong>Here is a copy of your enquiry:</strong></span>
                                </div>
                                <div class="detail">
                                    <span><strong>Name </strong></span>
                                    <span>: '.$name.'</span>
                                </div>
                                <div class="detail">
                                    <span><strong>Email</strong></span>
                                    <span>: '.$email.'</span>
                                </div>
                                <div class="detail">
                                    <span><strong>whatsapp </strong></span>
                                    <span>: '.$whatsapp.'</span>
                                </div>
                                <div class="detail">
                                    <span><strong>Country </strong></span>
                                    <span>: '.$country.'</span>
                                </div>
                            </div>

                            <div style="padding-top:15px; padding-bottom:10px;">
                                <p><strong>Enquiry:</strong></p>
                                <p>'.$enquiry.'</p>
                            </div>
                            <hr>
                            <div class="detail " style="margin-bottom:1rem;">
                                <span>Need help? Our support team is ready to assist you at tropialisexoticparadise@gmail.com</span>
                            </div>
                            <p>Best Regards, </p>
                            <p>Tropialis Team</p>
                        </div>
                        <div class="footer" style="padding: 15px; font-size: 14px; color: #333; background-color: #ffffff; border-radius: 8px; overflow: hidden; width: fit-content; max-width: 100%;">
                            <div style="background-color: #87CEEB; padding: 20px; border-radius: 12px; display: flex; justify-content: center; align-items: center; width: auto;">
                                <img class="img-fluid" style="max-width: 120px; height: auto;" src="'.$logoUrl.'" alt="Logo">
                            </div>
                            <p style="margin-top: 10px; font-size: 13px;">
                                Tropialis.com - PT. Tropialis Karya Nusantara, Jl. Srikandi 50, Nusa Dua, Benoa, Kuta Selatan, Badung, Bali, Indonesia 80361
                            </p>
                            <p>
                                <a href="https://www.tropialis.com/page/about-us/" target="_blank" style="color:black; text-decoration: none;">About Us</a> | 
                                <a href="https://www.tropialis.com/page/faq/" target="_blank" style="color:black; text-decoration: none;">FAQ</a> | 
                                <a href="https://wa.me/62881037336399" target="_blank" style="color:black; text-decoration: none;">Contact Us</a>
                            </p>
                        </div>
                    </div>
                </body>
                </html>
                    ';
                // Kirim Email
                $mail->send();
            } catch (Exception $e) {
                echo "Mailer Error: " . $mail->ErrorInfo;
            }
        }
}
}