<?php
use Phalcon\Mvc\Model;
class Rate_breakdown extends Model
{
	public $id;
    public $availability_id;
    public $qty_start;
    public $qty_end;
    public $publish_price;
    public $create_date;
    public $create_by;
}