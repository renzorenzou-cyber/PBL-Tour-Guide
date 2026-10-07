<?php
use Phalcon\Mvc\Model;
class Keywords extends Model
{
	public $id;
	public $keyword_name;
	public $keyword_url;
	public $keyword_description;
	public $keyword_hits;
	public $postdate;

}