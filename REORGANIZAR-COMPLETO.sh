#!/bin/bash
set -e

echo "== Reorganizando proyecto a arquitectura escalable =="

###############################################################################
# 1. Crear carpeta modules y mover módulos
###############################################################################
mkdir -p modules

for dir in 1_doc_normativos 2_actas_php 3_contabilidad_php 4_becas_php 5_inversiones 6_investigacion 7_alumnos 8_docentes 9_pagos 9_remuneraciones 10_reglamentos 13_decalogos 14_proyecto_general_desarrollo 15_plan_estudio; do
  [ -d "$dir" ] && mv "$dir" modules/
done

[ -d "11_otros_documentos" ] && mv 11_otros_documentos modules/

###############################################################################
# 2. Limpiar módulos (solo HTML + JS)
###############################################################################
mkdir -p backups

cd modules
for d in */; do
  [ -f "$d/api.php" ] && mv "$d/api.php" "../backups/${d%/}_api.php.bak"
  [ -f "$d/conexion.php" ] && mv "$d/conexion.php" "../backups/${d%/}_conexion.php.bak"
done
cd ..

###############################################################################
# 3. BaseAPI
###############################################################################
mkdir -p api

cat > api/BaseAPI.php << 'PHP'
<?php
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../includes/helpers.php';

abstract class BaseAPI {
    protected $db;
    protected $table;

    public function __construct() {
        $this->db = getDB();
        header('Content-Type: application/json; charset=utf-8');
    }

    public function handle() {
        switch ($_SERVER['REQUEST_METHOD']) {
            case 'GET': $this->get(); break;
            case 'POST': $this->post(); break;
            case 'PUT': $this->put(); break;
            case 'DELETE': $this->delete(); break;
            default: http_response_code(405);
        }
    }

    protected function get() {
        $id = $_GET['id'] ?? null;
        if ($id) {
            $q = $this->db->prepare("SELECT * FROM {$this->table} WHERE id=?");
            $q->execute([$id]);
            echo json_encode($q->fetch());
        } else {
            $q = $this->db->query("SELECT * FROM {$this->table}");
            echo json_encode($q->fetchAll());
        }
    }

    abstract protected function post();
    abstract protected function put();

    protected function delete() {
        $d = json_decode(file_get_contents("php://input"), true);
        $q = $this->db->prepare("DELETE FROM {$this->table} WHERE id=?");
        $q->execute([$d['id']]);
        echo json_encode(['success'=>true]);
    }
}
PHP

###############################################################################
# 4. API alumnos
###############################################################################
cat > api/alumnos.php << 'PHP'
<?php
require_once 'BaseAPI.php';

class AlumnosAPI extends BaseAPI {
    public function __construct() {
        parent::__construct();
        $this->table = 'alumnos';
    }

    protected function post() {
        $d = json_decode(file_get_contents("php://input"), true);
        $q = $this->db->prepare(
            "INSERT INTO alumnos(nombre,apellido,codigo,carrera) VALUES(?,?,?,?)"
        );
        $q->execute([$d['nombre'],$d['apellido'],$d['codigo'],$d['carrera']]);
        echo json_encode(['success'=>true]);
    }

    protected function put() {
        $d = json_decode(file_get_contents("php://input"), true);
        $q = $this->db->prepare(
            "UPDATE alumnos SET nombre=?,apellido=?,codigo=?,carrera=? WHERE id=?"
        );
        $q->execute([$d['nombre'],$d['apellido'],$d['codigo'],$d['carrera'],$d['id']]);
        echo json_encode(['success'=>true]);
    }
}

(new AlumnosAPI())->handle();
PHP

###############################################################################
# 5. Script JS alumnos
###############################################################################
mkdir -p modules/7_alumnos

cat > modules/7_alumnos/scripts.js << 'JS'
const API = '/api/alumnos.php';

async function cargar() {
  const r = await fetch(API);
  console.log(await r.json());
}

document.addEventListener('DOMContentLoaded', cargar);
JS

###############################################################################
# 6. index.html principal
###############################################################################
cat > index.html << 'HTML'
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<title>Portal Transparencia</title>
<link rel="stylesheet" href="/assets/css/base.css">
</head>
<body>
<h1>Portal de Transparencia</h1>
<ul>
  <li><a href="/modules/7_alumnos/">Alumnos</a></li>
</ul>
</body>
</html>
HTML

echo "== REESTRUCTURACIÓN COMPLETADA =="
