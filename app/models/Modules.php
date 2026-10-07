<?php
use Phalcon\Mvc\Model;
class modules extends Model
{
	public $id;
	public $name;
	public $slug;
	public $description;
	public $page_title;
	public $keywords;
	public $metadata;
	public $visitors;
	public $published_at;
	public $created_by;
	public $updated_by;
	public $created_at;
	public $updated_at;
	public $group;
}