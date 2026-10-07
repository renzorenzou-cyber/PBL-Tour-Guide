<?php
use Phalcon\Mvc\Model;
class Affiliates extends Model
{
	public $id;
	public $affiliate_parent;
	public $affiliate_email;
	public $affiliate_password;
	public $affiliate_name;
	public $affiliate_phone;
	public $affiliate_rank;
	public $affiliate_avatar;
	public $affiliate_status;
	public $postdate;
}