<?php
class GoogleSheetsAdapter {
    private $urls;
    
    public function __construct($module) {
        $config = require __DIR__ . '/../config/database.php';
        $this->url = $config['apps_script_urls'][$module];
    }
    
    public function get($params = []) {
        return $this->request('GET', $params);
    }
    
    public function post($data) {
        return $this->request('POST', $data);
    }
    
    public function put($id, $data) {
        return $this->request('PUT', array_merge(['id' => $id], $data));
    }
    
    public function delete($id) {
        return $this->request('DELETE', ['id' => $id]);
    }
    
    private function request($method, $data) {
        $url = $this->url;
        $data['action'] = strtolower($method);
        
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url . '?' . http_build_query($data));
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
        
        $response = curl_exec($ch);
        curl_close($ch);
        
        return json_decode($response, true);
    }
}