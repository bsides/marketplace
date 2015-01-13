<?php
namespace Direct\Model;

use Zend\I18n\Filter\NumberFormat;

/**
 * Class Category
 *
 * @package Direct\Model
 */
class Item
{
    public function fetchAll( array $params )
    {
        $return = [];
        $color[] = 'PB';
        $color[] = 'Cormia';
        $color[] = 'Cormia, PB';

        $format[] = 'Rodapé';
        $format[] = 'Meia Página';
        $format[] = 'Página Inteira';

        $column[] = 'Política';
        $column[] = 'Esportes';

        $newspaper[] = 'Estadão';
        $newspaper[] = 'Folha';
        $newspaper[] = 'O Globo';

        $weekDays[] = 'Seg';
        $weekDays[] = 'Ter';
        $weekDays[] = 'Dom';

        $determination = [ 'Padrão', 'Capa', 'Página Direita', 'Sou contra nomes gigantes'];

        for($x=0; $x<=rand(3,8); $x++) {
            $deal['id'] = rand(1,999);
            $deal['color'] = $color[rand(0,2)];
            $deal['price'] = 10000.01;
            $deal['column'] = $column[rand(0,1)];
            $deal['format'] = $format[rand(0,2)];
            $deal['determination'] =$determination[rand(0,3)];
            $deal['newspaper'] = $newspaper[rand(0,2)];
            $deal['weekDay'] = $weekDays[rand(0,2)];
            $deal['image'] = 'http://cdni.wired.co.uk/1920x1280/o_r/Pug.jpg';

            $return[] = $deal;
        }

        return $return;
    }
}
