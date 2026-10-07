<?php
use Phalcon\Mvc\Model;
class Hotdeals extends Model
{
	public $id;
	public $promo_name;
	public $promo_desc;
	public $hotdeal_type;
    public $hotdeal_value;
	public $rates;
	public $promo_status;
	public $created_by;
	public $created_date;
	public $published_by;
	public $published_date;
	public $date_range;
}