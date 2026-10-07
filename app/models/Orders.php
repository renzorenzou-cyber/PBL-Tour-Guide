<?php
use Phalcon\Mvc\Model;
class Orders extends Model
{
	public $id;
	public $code;
	public $voucher_number;
	public $customer_email;
	public $customer_name;
	public $customer_country;
	public $customer_phone;
	public $customer_note;
	public $payment_method;
	public $currency;
	public $tax;
	public $total;
	public $status;
	public $metadata;
	public $user;
	public $customer;
	public $payment;
	public $created_by;
	public $updated_by;
	public $created_at;
	public $updated_at;
	public $final_currency;
	public $agent;
	public $channel;
	public $activity_date;
	public $continous_number;
}