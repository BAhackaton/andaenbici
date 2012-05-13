<?php

// Database connection settings
   define("PG_DB"  , "routing");
   define("PG_HOST", "localhost"); 
   define("PG_USER", "postgres");
   define("PG_PORT", "5432"); 
   define("TABLE",   "calles");

   if (!isset($_REQUEST['startpoint']) || !isset($_REQUEST['finalpoint'])) {
   	help();
 	die();
   }
   // Retrieve start point
   $start = split(',',$_REQUEST['startpoint']);
   $startPoint = array($start[1], $start[0]);

   // Retrieve end point
   $end = split(',',$_REQUEST['finalpoint']);
   $endPoint = array($end[1], $end[0]);
   
   // Connect to database
   $dbcon = pg_connect("dbname=".PG_DB." host=".PG_HOST." user=".PG_USER);

   // Find the nearest edge
   $startEdge = findNearestEdge($startPoint, $dbcon);
   $endEdge   = findNearestEdge($endPoint, $dbcon);

   $sql = 	"SELECT nomb_ca_co as nombre, least(alt_ii, alt_di) as desde, greatest(alt_if, alt_df) as hasta, tipo_c, tiene_ciclovia, ST_AsGeoJSON(geom) as geom FROM shortest_path('
                SELECT gid as id,
                         source::integer,
                         target::integer,
                         peso::double precision as cost
                        FROM " . TABLE . "',
                ".$startEdge['source'].",
                ".$endEdge['target'].", false, false) sp left join " . TABLE . " c2 on c2.gid = sp.edge_id";

   // Perform database query
   $query = pg_query($dbcon,$sql); 
   
   // Return route as GeoJSON
   $result = array(); 
  
   
   $last = null;

   // Add edges to GeoJSON array
   while($edge=pg_fetch_assoc($query)) {  

        $geo = json_decode($edge['geom']);
        if (is_object($geo)) {
        	$coords = $geo->coordinates;
                $coords = $coords[0];
                $edge['geom'] = $coords;
	} else {
		$edge['geom'] = array();
	}

	if($last == null) {
		$last = $edge;
	} else {
		if (($last['nombre'] == $edge['nombre']) && ($last['tiene_ciclovia'] == $edge['tiene_ciclovia'])) {
			if ($edge['desde'] > $last['desde']) {
				$last['hasta'] = $edge['hasta'];
			} else {
				// Estamos yendo hacia atras en altura
				$last['desde'] = $edge['desde'];
				$last['reverse'] = true;
			}
			$last['geom'] = merge_points($last['geom'], $edge['geom']);	
		} else { 
			add_result($result, $last);
			$last = $edge;
		}
	}
   }

   if($last != null) {
	add_result($result, $last);
   }
	
   // Close database connection
   pg_close($dbcon);

   // Return routing result
   if (isset($_REQUEST['output']) && $_REQUEST['output'] == "json") {
	   header('Content-type: application/json',true);
	   echo json_encode($result, true);
   } else {
	header('Content-type: application/vnd.google-earth.kml+xml');
	echo "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
	echo <<<EOT
<kml xmlns="http://www.opengis.net/kml/2.2">"
	<Document>
		<description>Mejor camino en bici</description>
    <Style id="calle">
      <LineStyle>
        <color>ffff0000</color>
        <width>4</width>
      </LineStyle>
    </Style>
    <Style id="ciclovia">
      <LineStyle>
        <color>ff009900</color>
        <width>4</width>
      </LineStyle>
    </Style>
EOT;
	foreach($result as $item) {
		$name = "Tomar " . $item['nombre'] . " del " . $item['desde'] . " al " . $item['hasta'];
		$style = $item['tiene_ciclovia'] == 't' ? "#ciclovia" : "#calle";
		echo "<Placemark><name>$name</name><styleUrl>$style</styleUrl><LineString><altitudeMode>relative</altitudeMode><coordinates>";
		foreach($item['geom'] as $coord) {
			echo $coord[0]. "," . $coord[1] . ",0 \n";
		}
		echo "</coordinates></LineString></Placemark>";
	};
	echo <<<EOT
	</Document>
</kml>
EOT;

   }


   // FUNCTION findNearestEdge
   function findNearestEdge($lonlat, $con) {

      $sql = "SELECT gid, source, target, geom, nomb_ca_co, 
		          distance(geom, GeometryFromText(
	                   'POINT(".$lonlat[0]." ".$lonlat[1].")', 4326)) AS dist 
	             FROM ".TABLE."
	             WHERE geom && setsrid(
	                   'BOX3D(".($lonlat[0]-0.1)." 
	                          ".($lonlat[1]-0.1).", 
	                          ".($lonlat[0]+0.1)." 
	                          ".($lonlat[1]+0.1).")'::box3d, 4326) 
	             ORDER BY dist LIMIT 1";

      $query = pg_query($con,$sql);  

      $result = pg_fetch_assoc($query); 
	return $result;      

   }

   function add_result(&$result, $item) {
	if(!$item['nombre'])
		return;
	if(isset($item['reverse'])) {
		list($item['desde'], $item['hasta']) = array($item['hasta'], $item['desde']);
		unset($item['reverse']);
	}
	array_push($result, $item);
   }


   function merge_points($oldPoints, $newPoints) {
	if( end($oldPoints) == reset($newPoints) ){
		array_pop($oldPoints);
	}
	return array_merge($oldPoints, $newPoints);
   }

   function help() {
$url = "http://" . $_SERVER['SERVER_NAME'].$_SERVER['REQUEST_URI'];
$urlencoded = urlencode($url);
echo <<<EOD
<h1>Webservice Anda en Bici</h1>
Este es un webservice que permite determinar el mejor camino para ir en bici entre dos puntos de la Ciudad de Buenos Aires.

<h2>Modo de uso</h2>
<code>$url?startpoint=[origen]&finalpoint=[destino]&output=[formato]</code>
<p>
Donde
<ul>
<li><h3>origen</h3>Coordenadas del punto de origien, en formato <code>longitud,latitud</code>. Ejemplo: <code>startpoint=-34.555528,-58.462515</code> (Av. Cabildo y Av. Congreso)</li>
<li><h3>destino</h3>Coordenadas del punto de origien, en formato <code>longitud,latitud</code>. Ejemplo: <code>finalpoint=-34.603291,-58.375229</code> (Florida y Av. Corrientes)</li>
<li><h3>formato (optional)</h3>Especifica el formato en que son devueltos los resultados. Los posibles valores son <code>json</code> y <code>kml (por defecto)</code>. KML se puede utilizar directamente con googlemaps poniendo la url del webservice en el campo de b&uacute;squeda <a href="http://maps.google.com/maps?q=$urlencoded%3Fstartpoint%3D-34.555528,-58.462515%26finalpoint%3D-34.603291,-58.375229%26&hl=es&sll=-34.547313,-58.47065&sspn=0.007264,0.013733&t=m&z=13" target="_blank">Ver ejemplo</a></li>
</ul>
</p>
EOD;
   }
