
import React from 'react';
import { Shield, TrendingUp, Users, AlertTriangle } from 'lucide-react';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';

interface SafetyAnalyticsProps {
  routes: any[];
}

const SafetyAnalytics: React.FC<SafetyAnalyticsProps> = ({ routes }) => {
  const averageSafety = routes.length > 0 
    ? routes.reduce((acc, route) => acc + route.safetyScore, 0) / routes.length 
    : 0;

  const safetyInsights = [
    {
      title: 'Hora pico',
      description: 'Mayor vigilancia en rutas principales',
      level: 'high',
      icon: TrendingUp
    },
    {
      title: 'Inteligencia colectiva',
      description: `${Math.floor(Math.random() * 200 + 300)} usuarios reportando`,
      level: 'active',
      icon: Users
    },
    {
      title: 'Alertas activas',
      description: 'Sin incidentes reportados',
      level: 'safe',
      icon: AlertTriangle
    }
  ];

  const getLevelColor = (level: string) => {
    switch (level) {
      case 'high': return 'text-orange-400';
      case 'active': return 'text-blue-400';
      case 'safe': return 'text-green-400';
      default: return 'text-white';
    }
  };

  return (
    <Card className="glass-effect border-white/20">
      <CardHeader className="pb-3">
        <CardTitle className="text-white text-lg flex items-center">
          <Shield className="w-5 h-5 mr-2 text-green-400" />
          Análisis de Seguridad
        </CardTitle>
      </CardHeader>
      
      <CardContent className="space-y-4">
        <div className="flex items-center justify-between">
          <span className="text-sm text-muted-foreground">Seguridad promedio</span>
          <Badge className={`${averageSafety >= 90 ? 'bg-green-600' : averageSafety >= 80 ? 'bg-yellow-600' : 'bg-red-600'} text-white`}>
            {averageSafety.toFixed(1)}%
          </Badge>
        </div>

        <div className="space-y-3">
          {safetyInsights.map((insight, index) => (
            <div key={index} className="flex items-start space-x-3">
              <insight.icon className={`w-4 h-4 mt-0.5 ${getLevelColor(insight.level)}`} />
              <div className="flex-1 space-y-1">
                <div className="text-sm font-medium text-white">
                  {insight.title}
                </div>
                <div className="text-xs text-muted-foreground">
                  {insight.description}
                </div>
              </div>
            </div>
          ))}
        </div>

        <div className="glass-effect rounded-lg p-3 text-center">
          <div className="text-xs text-muted-foreground mb-1">
            Datos actualizados hace
          </div>
          <div className="text-sm font-medium text-green-400">
            2 minutos
          </div>
        </div>
      </CardContent>
    </Card>
  );
};

export default SafetyAnalytics;
