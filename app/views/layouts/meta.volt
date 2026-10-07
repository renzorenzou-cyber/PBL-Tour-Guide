<head>
  <!-- Required Meta Tags Always Come First -->
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta http-equiv="x-ua-compatible" content="ie=edge">


  {{ get_title() }}
  <meta name="description" content="{{ metadesc }}">
  <script type="application/ld+json">
    {{ schemaJson }}
  </script>
  <!-- Global stylesheets -->
  {{ assets.outputCss('header') }}
  <!-- /global stylesheets -->
  <link rel="canonical" href="<?php echo $this->request->getScheme() . '://' . $this->request->getHttpHost() . $this->request->getURI(); ?>" />
  <!-- Google Tag Manager -->
  <!-- Google tag (gtag.js) -->
  <script async src="https://www.googletagmanager.com/gtag/js?id=G-NJF03LBGJE"></script>
  <script>
    window.dataLayer = window.dataLayer || [];
    function gtag(){dataLayer.push(arguments);}
    gtag('js', new Date());

    gtag('config', 'G-NJF03LBGJE');
  </script>
  <!-- End Google Tag Manager -->
  <?php /*?><script type='text/javascript' src='https://platform-api.sharethis.com/js/sharethis.js#property=66a595197fa1e900193708bd&product=sop' async='async'></script><?php */?>
  <link rel="shortcut icon" type="image/x-icon" href="{{ url('img/favicon.ico') }}"/>
	<link rel="apple-touch-icon" sizes="57x57" href="{{ url('img/favicons/apple-icon-57x57.png') }}">
	<link rel="apple-touch-icon" sizes="60x60" href="{{ url('img/favicons/apple-icon-60x60.png') }}">
	<link rel="apple-touch-icon" sizes="72x72" href="{{ url('img/favicons/apple-icon-72x72.png') }}">
	<link rel="apple-touch-icon" sizes="76x76" href="{{ url('img/favicons/apple-icon-76x76.png') }}">
	<link rel="apple-touch-icon" sizes="114x114" href="{{ url('img/favicons/apple-icon-114x114.png') }}">
	<link rel="apple-touch-icon" sizes="120x120" href="{{ url('img/favicons/apple-icon-120x120.png') }}">
	<link rel="apple-touch-icon" sizes="144x144" href="{{ url('img/favicons/apple-icon-144x144.png') }}">
	<link rel="apple-touch-icon" sizes="152x152" href="{{ url('img/favicons/apple-icon-152x152.png') }}">
	<link rel="apple-touch-icon" sizes="180x180" href="{{ url('img/favicons/apple-icon-180x180.png') }}">
	<link rel="icon" type="image/png" sizes="192x192"  href="{{ url('img/favicons/android-icon-192x192.png') }}">
	<link rel="icon" type="image/png" sizes="32x32" href="{{ url('img/favicons/favicon-32x32.png') }}">
	<link rel="icon" type="image/png" sizes="96x96" href="{{ url('img/favicons/favicon-96x96.png') }}">
	<link rel="icon" type="image/png" sizes="16x16" href="{{ url('img/favicons/favicon-16x16.png') }}">
	<link rel="manifest" href="/manifest.json">
	<meta name="msapplication-TileColor" content="#ffffff">
	<meta name="msapplication-TileImage" content="{{ url('img/favicons/ms-icon-144x144.png') }}">
	<meta name="theme-color" content="#ffffff">
  <?php /*?><meta name="google-adsense-account" content="ca-pub-7406190888359791">
  <script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-7406190888359791"
     crossorigin="anonymous"></script><?php */?>
</head>