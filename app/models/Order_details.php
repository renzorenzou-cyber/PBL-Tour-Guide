<?php
use Phalcon\Mvc\Model;
class Order_details extends Model
{
	public $id;
	public $module_id;
	public $module_name;
	public $provider_name;
	public $product_name;
	public $quantity;
	public $product_price;
	public $subtotal_price;
	public $paid_price;
	public $discount;
	public $down_payment;
	public $order_id;
	public $module;
	public $provider;
	public $product;
	public $specific;
	public $created_by;
	public $updated_by;
	public $created_at;
	public $updated_at;
	public $net_price;
	public $product_image;
	public $extra_info;
	public $detail_status;
	public $id_rate;
	public $rate_name;
	public $id_opt_rate;
	public $rate_opt_name;
	public $subtotal_price_net;
	public $order_days;
	public $order_date;
	public $order_time;
	public $wa_status;
	public $completed_date;
	public $paid_status;
	public $delay_status;
	public $reason;
}