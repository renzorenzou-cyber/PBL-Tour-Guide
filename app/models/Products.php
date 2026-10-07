<?php
use Phalcon\Mvc\Model;
class Products extends Model
{
	public $id;
	public $name;
	public $slug;
	public $description;
	public $page_title;
	public $metadata;
	public $base_price;
	public $down_payment;
	public $specific;
	public $cart;
	public $locale;
	public $published_at;
	public $created_by;
	public $updated_by;
	public $created_at;
	public $updated_at;
	public $provider;
	public $rate;
	public $group_product;
	public $sku;
	public $product_status;
	public $ordered;
}