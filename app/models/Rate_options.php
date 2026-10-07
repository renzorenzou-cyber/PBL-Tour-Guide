<?php
use Phalcon\Mvc\Model;
class Rate_options extends Model
{
	public $id;
	public $id_rate;
	public $rate_option_name;
	public $rate_option_unit;
	public $rate_option_price;
	public $rate_options_text;
	public $published_at;
	public $created_by;
	public $updated_by;
	public $created_at;
	public $updated_at;
	public $rate_option_price_basic;
	public $start_time;
	public $end_time;
	public $step;
	public $duration;
	public $start_date;
	public $end_date;
	public $booking_window_start;
	public $booking_window_end;
	public $min_qty;
	public $max_qty;
	public $stock;
	public $is_stock;
}