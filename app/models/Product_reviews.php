<?php
use Phalcon\Mvc\Model;
class Product_reviews extends Model
{
	public $id;
	public $parent_id;
	public $product_id;
	public $review_star;
	public $review_comment;
	public $review_name;
	public $review_country;
	public $review_job;
	public $created_at;
	public $created_by;
}