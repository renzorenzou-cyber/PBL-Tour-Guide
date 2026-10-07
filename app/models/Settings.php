<?php
use Phalcon\Mvc\Model;
class Settings extends Model
{
	public $id;
	public $currency;
	public $published_at;
	public $created_by;
	public $updated_by;
	public $created_at;
	public $updated_at;
	public $currencies;
	public $languages;
	public $available_currencies;
	public $countries;
}