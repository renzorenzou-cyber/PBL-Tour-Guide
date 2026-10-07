<?php
use Phalcon\Mvc\Model;
class Rate_availability extends Model
{
	public $id;
    public $module_id;
    public $id_rate_opt;
    public $date_available;
    public $time_available;
    public $day_number;
    public $publish_price;
    public $rate_status;
    public $create_date;
    public $create_by;
    public $publish_date;
    public $publish_by;
}