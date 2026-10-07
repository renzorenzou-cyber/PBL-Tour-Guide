<?php
use Phalcon\Mvc\Model;
class Currencies_daily_rate extends Model
{
	public $id;
    public $iso3;
    public $date;
    public $conversion_rate;
    public $update_date;
}