<?php
use Phalcon\Mvc\Model;
class Articles extends Model
{
	public $id;
	public $article_title;
	public $article_slug;
	public $article_text;
	public $article_status;
	public $article_category;
	public $post_by;
	public $post_date;
	public $publish_by;
	public $publish_date;
	public $page_title;
	public $meta_description;
	public $visit_count;
}