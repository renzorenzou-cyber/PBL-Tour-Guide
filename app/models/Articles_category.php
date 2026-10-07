<?php
use Phalcon\Mvc\Model;
class Articles_category extends Model
{
	public $id;
	public $category_parent;
	public $category_name;
	public $category_url;
	public $category_sort;
	public $category_status;
	public $is_child;
}