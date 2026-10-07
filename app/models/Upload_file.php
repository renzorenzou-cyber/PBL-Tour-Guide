<?php
use Phalcon\Mvc\Model;
class upload_file extends Model
{
	public $id;
	public $name;
	public $alternativeText;
	public $caption;
	public $width;
	public $height;
	public $formats;
	public $hash;
	public $ext;
	public $mime;
	public $size;
	public $url;
	public $previewUrl;
	public $provider;
	public $provider_metadata;
	public $created_by;
	public $updated_by;
	public $created_at;
	public $updated_at;
}