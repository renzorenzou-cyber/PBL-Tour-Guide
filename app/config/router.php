<?php

$router = $di->getRouter();

// Define your routes here
$router->add('/sitemap.xml', [
    'controller' => 'index',
    'action'     => 'sitemap'
]);

// $router->add(
//     '/ads.txt',
//     [
//         'controller' => 'index',
//         'action' => 'ads'
//     ]
// );

$router->add('/ads.txt', [
    'controller' => 'ads',
    'action'     => 'ads'
]);

$router->add(
	'/{id}/{url}/',
	[
		'controller' => 'product',
		'action' => 'detail',
		'id' => 1,
		'url' => 2
	]
);

$router->add(
	'/{id}/{url}/review/{page:[0-9]+}',
	[
		'controller' => 'product',
		'action' => 'detail',
		'id' => 1,
		'url' => 2
	]
);

$router->add(
	'/{id}/{url}/review/rating/{star}/{page:[0-9]+}',
	[
		'controller' => 'product',
		'action' => 'detail',
		'id' => 1,
		'url' => 2,
		'star' => 3,
	]
);

$router->add(
	'/{id}/{url}/review/rating/{star}/{sort}/{page:[0-9]+}',
	[
		'controller' => 'product',
		'action' => 'detail',
		'id' => 1,
		'url' => 2,
		'star' => 3,
        'sort' => 4,
        'page' => 5,
	]
);

$router->add(
    '/{id}/{url}/review/{sort}/{page:[0-9]+}',
    [
        'controller' => 'product',
        'action'     => 'detail',
        'id'         => 1,
        'url'        => 2,
        'sort'       => 3,
        'page'       => 4,
    ]
);

$router->add(
    '/product/availability/',
    [
        'controller' => 'product',
        'action' => 'availability',
    ]
);

$router->add(
    '/product/loadratelist/',
    [
        'controller' => 'product',
        'action' => 'loadratelist',
    ]
);

/*CATEGORY*/
$router->add(
    '/category/{category_url}/',
    [
        'controller' => 'category',
        'action' => 'detail',
    ]
);

$router->add(
    '/category/{category_url}/search/{search_url}/',
    [
        'controller' => 'search',
        'action' => 'searchcategory',
        'category_url' => 1,
        'search_url' => 2
    ]
);

$router->add(
    '/category/{category_url}/search/{search_url}/{page:[0-9]+}',
    [
        'controller' => 'search',
        'action' => 'searchcategory',
        'category_url' => 1,
        'search_url' => 2,
        'page' => 3
    ]
);

$router->add(
    '/category/{category_url}/rating/',
    [
        'controller' => 'category',
        'action' => 'ratingfilter',
    ]
);

$router->add(
    '/category/{category_url}/{page:[0-9]+}',
    [
        'controller' => 'category',
        'action' => 'detail',
    ]
);

$router->add(
    '/category/{category_url}/rating/{page:[0-9]+}',
    [
        'controller' => 'category',
        'action'     => 'ratingfilter',
    ]
);


$router->add(
	'/lifestyle/{article_id}/{article_url}/',
	[
		'controller' => 'articles',
		'action' => 'detail',
        'article_id' => 1,
		'article_url' => 2
	]
);

$router->add(
	'/lifestyle/',
	[
		'controller' => 'articles',
		'action' => 'index'
	]
);

$router->add(
	'/page/{page_url}/',
	[
		'controller' => 'page',
		'action' => 'detail',
		'page_url' => 1
	]
);

$router->add(
	'/search/{search_url}/',
	[
		'controller' => 'search',
		'action' => 'index',
		'search_url' => 1
	]
);

$router->add(
    '/search/{search_url}/{page:[0-9]+}',
    [
        'controller' => 'search',
        'action' => 'index',
        'search_url' => 1,
        'page' => 2
    ]
);

$router->add(
    '/cart/',
    [
        'controller' => 'cart',
        'action' => 'index'
    ]
);

$router->add(
    '/cart/addtocart/',
    [
        'controller' => 'cart',
        'action' => 'addtocart'
    ]
);

$router->add(
    '/cart/clearcart/',
    [
        'controller' => 'cart',
        'action' => 'clearcart'
    ]
);

$router->add(
    '/cart/updatecart/',
    [
        'controller' => 'cart',
        'action' => 'updatecart'
    ]
);

$router->add(
    '/cart/removeitem/',
    [
        'controller' => 'cart',
        'action' => 'removeitem'
    ]
);

$router->add(
    '/cart/makepayment/',
    [
        'controller' => 'cart',
        'action' => 'makepayment',
    ]
);

$router->add(
    '/cart/loadextra/',
    [
        'controller' => 'cart',
        'action' => 'loadextra',
    ]
);

$router->add(
    '/cart/loadaddon/',
    [
        'controller' => 'cart',
        'action' => 'loadaddon',
    ]
);

$router->add(
    '/cart/addaddon/',
    [
        'controller' => 'cart',
        'action' => 'addaddons',
    ]
);

$router->add(
    '/cart/deleteaddon/',
    [
        'controller' => 'cart',
        'action' => 'deleteaddon',
    ]
);

$router->add(
    '/cart/promotions/',
    [
        'controller' => 'cart',
        'action' => 'promotion',
    ]
);
/*CATEGORY*/

// $router->add(
//     '/order/success/',
//     [
//         'controller' => 'cart',
//         'action' => 'success',
//     ]
// );

$router->add(
    '/order/success/{paymentId}',
    [
        'controller' => 'cart',
        'action' => 'success',
        'paymentId' => 1
    ]
);

$router->add(
    '/account/signup/',
    [
        'controller' => 'account',
        'action' => 'signup'
    ]
);

$router->add(
    '/account/signupprocess/',
    [
        'controller' => 'account',
        'action' => 'signupprocess'
    ]
);

$router->add(
    '/account/activation/{hashId}',
    [
        'controller' => 'account',
        'action' => 'activation',
        'hashId' => 1

    ]
);

$router->add(
    '/account/activation/{hashId}/success',
    [
        'controller' => 'account',
        'action' => 'activationSuccess',
        'hashId' => 1

    ]
);

$router->add(
    '/account/resendactivation/',
    [
        'controller' => 'account',
        'action' => 'resendactivation',

    ]
);

$router->add(
    '/account/login/',
    [
        'controller' => 'account',
        'action' => 'login'
    ]
);

$router->add(
    '/account/loginprocess/',
    [
        'controller' => 'account',
        'action' => 'loginprocess'
    ]
);

$router->add(
    '/account/editprofilepicture/',
    [
        'controller' => 'account',
        'action' => 'editprofilepicture'
    ]
);

$router->add(
    '/account/forgetpassword/',
    [
        'controller' => 'account',
        'action' => 'forgetpassword'
    ]
);

$router->add(
    '/account/forgetpasswordprocess/',
    [
        'controller' => 'account',
        'action' => 'forgetpasswordprocess'
    ]
);

$router->add(
    '/account/requestnewpassword/{hashId}',
    [
        'controller' => 'account',
        'action' => 'requestnewpassword',
        'hashId' => 1
    ]
);

$router->add(
    '/account/requestnewpasswordprocess/',
    [
        'controller' => 'account',
        'action' => 'requestnewpasswordprocess',
    ]
);

$router->add(
    '/account/logout/',
    [
        'controller' => 'account',
        'action' => 'logout'
    ]
);

$router->add(
    '/account/orders/',
    [
        'controller' => 'account',
        'action' => 'orders'
        ]
    );
        
$router->add(
    '/account/cancelled/',
    [
        'controller' => 'account',
        'action' => 'orders'
    ]
);

$router->add(
    '/account/cancelled/{page:[0-9]+}',
    [
        'controller' => 'account',
        'action' => 'orders'
    ]
);

$router->add(
    '/account/login_security/',
    [
        'controller' => 'account',
        'action' => 'orders'
    ]
);
    
$router->add(
    '/account/review/',
    [
        'controller' => 'account',
        'action' => 'orders'
    ]
);
    
$router->add(
    '/account/review/{page:[0-9]+}',
    [
        'controller' => 'account',
        'action' => 'orders'
    ]
);
    
$router->add(
    '/account/wishlist/',
    [
        'controller' => 'account',
        'action' => 'orders'
    ]
);
    
$router->add(
    '/account/wishlist/{page:[0-9]+}',
    [
        'controller' => 'account',
        'action' => 'orders'
    ]
);
    
$router->add(
    '/account/editprofile/',
    [
        'controller' => 'account',
        'action' => 'editprofile'
    ]
);
    
$router->add(
    '/account/changepassword/',
    [
        'controller' => 'account',
        'action' => 'changepassword'
    ]
);
    
$router->add(
    '/account/orders/cancel-order/',
    [
        'controller' => 'account',
        'action' => 'cancel'
    ]
);

$router->add(
    '/index/changecurrency/',
    [
        'controller' => 'index',
        'action' => 'changecurrency'
    ]
);

$router->add(
    '/index/changeareas/',
    [
        'controller' => 'index',
        'action' => 'changeareas'
    ]
);

$router->add(
    '/area/{area}/',
    [
        'controller' => 'area',
        'action' => 'index'
    ]
);

$router->add(
    '/area/{area}/{page:[0-9]+}',
    [
        'controller' => 'area',
        'action' => 'index',
    ]
);

$router->add(
    '/area/{area}/{subarea}/',
    [
        'controller' => 'area',
        'action' => 'detail',
        'area' => 1,
        'subarea' => 2,
    ]
);

$router->add(
    '/area/{area}/{subarea}/{page:[0-9]+}',
    [
        'controller' => 'area',
        'action' => 'detail',
    ]
);

$router->add(
    '/area/{area}/{subarea}/rating/{page:[0-9]+}',
    [
        'controller' => 'area',
        'action'     => 'ratingfilter',
    ]
);


$router->add(
    '/area/{area}/{subarea}/search/{search_url}/',
    [
        'controller' => 'search',
        'action' => 'searcharea'
    ]
);

$router->add(
	'/search/{search_url}/area/{area}/',
	[
		'controller' => 'search',
		'action' => 'searcharea',
		'search_url' => 1,
		'area' => 2
	]
);

$router->add(
	'/page/cookies-policy/',
	[
		'controller' => 'page',
		'action' => 'cookies'
	]
);

$router->add(
	'/provider/{provider_name}/',
	[
		'controller' => 'provider',
		'action' => 'index',
        'provider_name' => 1
	]
);

$router->add(
	'/provider/{provider_name}/reviews/',
	[
		'controller' => 'provider',
		'action' => 'index',
		'provider_name' => 1,
	]
);

$router->add(
	'/provider/{provider_name}/reviews/{reviewpage:[0-9]+}',
	[
		'controller' => 'provider',
		'action' => 'index',
		'provider_name' => 1,
	]
);

$router->add(
	'/provider/{provider_name}/products/',
	[
		'controller' => 'provider',
		'action' => 'index',
		'provider_name' => 1,
	]
);

$router->add(
	'/provider/{provider_name}/products/{page:[0-9]+}',
	[
		'controller' => 'provider',
		'action' => 'index',
		'provider_name' => 1,
	]
);

$router->add(
	'/provider/{provider_name}/location/',
	[
		'controller' => 'provider',
		'action' => 'index',
		'provider_name' => 1,
	]
);

$router->add('/account/logingoogle', [
    'controller' => 'account',
    'action'     => 'logingoogle',
]);

$router->add('/account/callbackgoogle', [
    'controller' => 'account',
    'action'     => 'callbackgoogle',
]);

$router->add(
	'/wishlist/',
	[
		'controller' => 'wishlist',
		'action' => 'wishlist'
	]
);

$router->add(
	'/wishlist/{page:[0-9]+}',
	[
		'controller' => 'wishlist',
		'action' => 'wishlist'
	]
);

$router->add(
	'/wishlist/add',
	[
		'controller' => 'account',
		'action' => 'addwishlist'
	]
);

$router->add(
	'/wishlist/remove',
	[
		'controller' => 'account',
		'action' => 'removewishlist'
	]
);

$router->add(
	'/page/enquiry/',
	[
		'controller' => 'page',
		'action' => 'enquiry'
	]
);

$router->handle();
