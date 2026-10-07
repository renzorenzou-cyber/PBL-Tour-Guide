<?php
use Phalcon\Mvc\Model;
class Currencies extends Model
{
	public $id;
    public $symbol;
    public $iso3;
    public $currency;
    public $country_name;
    public $currency_status;
    public $icon;
    public $flag;
}