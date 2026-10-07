<?php
use Phalcon\Mvc\Model;
class Extras_infos extends Model
{
	public $id;
	public $extra_name;
	public $extra_name_slug;
	public $extra_type;
	public $extra_value;
	public $published_at;
	public $created_by;
	public $updated_by;
	public $created_at;
	public $updated_at;
}