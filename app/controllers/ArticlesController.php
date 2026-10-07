<?php

class ArticlesController extends ControllerBase
{
    public function indexAction(){
        $this->tag->setTitle('Tropialis Lifestyle');
        $q = "SELECT a.id, a.article_title, a.article_slug, a.article_text, a.article_status, a.article_category, a.publish_date, a.page_title, a.meta_description, a.visit_count, (SELECT f.name FROM Upload_file_morph uf LEFT JOIN Upload_file f ON f.id = uf.upload_file_id WHERE uf.related_type = 'articles' AND uf.related_id = a.id LIMIT 0,1) as picture FROM Articles a WHERE article_status = 1 ORDER BY a.id DESC LIMIT 0,6";
		$row = $this->modelsManager->executeQuery($q);
		$this->view->setVar('articles',$row);
        $this->view->pick('article/index');
    }

    public function detailAction(){
        $q = "SELECT a.id, a.article_title, a.article_slug, a.article_text, a.article_status, a.article_category, a.publish_date, a.page_title, a.meta_description, a.visit_count, (SELECT f.name FROM Upload_file_morph uf LEFT JOIN Upload_file f ON f.id = uf.upload_file_id WHERE uf.related_type = 'articles' AND uf.related_id = a.id LIMIT 0,1) as picture FROM Articles a WHERE a.id = '".$this->dispatcher->getParam('article_id')."' ";
		$row = $this->modelsManager->executeQuery($q);
		$this->view->setVar('article',$row[0]);
        $this->tag->setTitle($row[0]['article_title']);
        $this->view->pick('article/detail');
    }

}