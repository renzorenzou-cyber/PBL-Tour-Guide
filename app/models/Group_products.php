<?php
use Phalcon\Mvc\Model;
class Group_products extends Model
{
	public $id;
	public $group_product_parent;
	public $group_product;
	public $group_product_url;
	public $published_at;
    public $created_by;
    public $updated_by;
    public $created_at;
    public $updated_at;
    public $group_product_sort;
    public $group_product_status;
    public $group_description;
    public $group_pagetitle;
}