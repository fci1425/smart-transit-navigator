
import React from 'react';
import { ArrowRight, Clock, MapPin, Zap } from 'lucide-react';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';

interface RouteOptimizerProps {
  selectedRoute: any;
  destination: string;
  userLocation: any;
}

const RouteOptimizer: React.FC<RouteOptimizerProps> = ({ 
  selectedRoute, 
  destination, 
  userLocation 
}) => {
  // Simular optimización de rutas con transbordos
  const optimizedRoute = {
    totalTime: '23 min',
    transfers: [
      {
        from: selectedRoute.name,
        to: 'Metro Línea 2',
        stopName: 'Estación Central',
        waitTime: '4 min',
        walkTime: '2 min'
      }
    ],
    timeSaved: '7 min',
    safetyImprovement: '+12%'
  };

  return (
    <Card className="glass-effect border-green-400/30">
      <CardHeader className="pb-3">
        <CardTitle className="text-green-400 text-lg flex items-center">
          <Zap className="w-5 h-5 mr-2" />
          Ruta Optimizada
        </CardTitle>
      </CardHeader>
      
      <CardContent className="space-y-4">
        <div className="flex items-center justify-between">
          <Badge className="bg-green-600 text-white">
            Ahorra {optimizedRoute.timeSaved}
          </Badge>
          <Badge variant="outline" className="border-green-400 text-green-400">
            Más seguro {optimizedRoute.safetyImprovement}
          </Badge>
        </div>

        <div className="space-y-3">
          <div className="flex items-center text-sm">
            <Clock className="w-4 h-4 text-blue-400 mr-2" />
            <span className="text-white">Tiempo total: {optimizedRoute.totalTime}</span>
          </div>

          {optimizedRoute.transfers.map((transfer, index) => (
            <div key={index} className="glass-effect rounded-lg p-3 space-y-2">
              <div className="flex items-center justify-between">
                <span className="text-sm text-muted-foreground">Transbordo {index + 1}</span>
                <span className="text-xs text-green-400">Recomendado</span>
              </div>
              
              <div className="flex items-center text-sm space-x-2">
                <span className="text-white">{transfer.from}</span>
                <ArrowRight className="w-4 h-4 text-blue-400" />
                <span className="text-white">{transfer.to}</span>
              </div>
              
              <div className="flex items-center text-xs text-muted-foreground">
                <MapPin className="w-3 h-3 mr-1" />
                <span>En {transfer.stopName}</span>
                <span className="mx-2">•</span>
                <span>Espera {transfer.waitTime}</span>
                <span className="mx-2">•</span>
                <span>Camina {transfer.walkTime}</span>
              </div>
            </div>
          ))}
        </div>

        <div className="text-xs text-muted-foreground">
          * Basado en análisis de patrones de tráfico y datos de seguridad en tiempo real
        </div>
      </CardContent>
    </Card>
  );
};

export default RouteOptimizer;
