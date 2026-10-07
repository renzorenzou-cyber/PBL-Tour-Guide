<?php
use Phalcon\Mvc\Model;
class Areas extends Model
{
	public $id_area;
    public $iso2;
    public $area_parent;
    public $area_name;
    public $area_url;
    public $area_status;
    public $area_description;
    public $area_view;
}