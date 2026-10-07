<?php
use Phalcon\Mvc\Model;
class Promotions extends Model
{
	public $id;
	public $promo_code;
	public $promo_name;
	public $promo_desc;
	public $promo_status;
	public $promo_type;
	public $promo_value;
	public $created_by;
	public $created_date;
	public $published_by;
	public $published_date;
}