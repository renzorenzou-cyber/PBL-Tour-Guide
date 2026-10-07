<?php
use Phalcon\Mvc\Model;
class providers extends Model
{
	public $id;
	public $name;
	public $slug;
	public $description;
	public $address;
	public $country;
	public $state;
	public $city;
	public $location;
	public $zipcode;
	public $phone;
	public $email;
	public $website;
	public $latitude;
	public $longitude;
	public $bookable;
	public $base_currency;
	public $module;
	public $product;
	public $cart;
	public $locale;
	public $published_at;
	public $created_by;
	public $updated_by;
	public $created_at;
	public $updated_at;
	public $province;
	public $district;
	public $sub_district;
	public $provider_code;
	public $channel_color;
	public $template_note;
	public $provider_status;
}