<?php
use Phalcon\Mvc\Model;
class Rates extends Model
{
	public $id;
	public $title;
	public $start;
	public $end;
	public $price;
	public $margin;
	public $discount;
	public $product;
	public $created_by;
	public $updated_by;
	public $created_at;
	public $updated_at;
	public $publish_price;
	public $min_order;
	public $max_order;
	public $channel;
	public $start_time;
	public $end_time;
}