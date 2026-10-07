<?php
use Phalcon\Mvc\Model;
class Menu_accesses extends Model
{
	public $id;
    public $is_parent;
    public $parent_id;
    public $name;
    public $url;
    public $is_active;
    public $icon;
    public $slug;
    public $sort;
    public $route_name;
    public $published_at;
    public $created_by;
    public $updated_by;
    public $created_at;
    public $updated_at;
}