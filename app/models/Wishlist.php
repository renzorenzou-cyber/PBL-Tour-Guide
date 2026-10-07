<?php
use Phalcon\Mvc\Model;
class Wishlist extends Model
{
	public $id;
    public $customer_email;
    public $created_at;
}