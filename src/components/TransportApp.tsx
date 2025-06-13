
import React, { useState, useEffect } from 'react';
import { MapPin, Navigation, Clock, Shield, Zap, QrCode } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Card, CardContent } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import NFCPayment from './NFCPayment';
import QRScanner from './QRScanner';
import RouteOptimizer from './RouteOptimizer';
import SafetyAnalytics from './SafetyAnalytics';

interface UserLocation {
  lat: number;
  lng: number;
  address: string;
}

interface BusRoute {
  id: string;
  number: string;
  name: string;
  nextArrival: string;
  safetyScore: number;
  distance: number;
  stops: string[];
  realTimeUpdates: boolean;
}

const TransportApp = () => {
  const [userLocation, setUserLocation] = useState<UserLocation | null>(null);
  const [origin, setOrigin] = useState('');
  const [destination, setDestination] = useState('');
  const [nearbyRoutes, setNearbyRoutes] = useState<BusRoute[]>([]);
  const [selectedRoute, setSelectedRoute] = useState<BusRoute | null>(null);
  const [showPayment, setShowPayment] = useState(false);
  const [showQRScanner, setShowQRScanner] = useState(false);
  const [isLoading, setIsLoading] = useState(false);

  // Simulated real-time data
  useEffect(() => {
    const interval = setInterval(() => {
      setNearbyRoutes(prev => prev.map(route => ({
        ...route,
        nextArrival: updateArrivalTime(route.nextArrival),
        safetyScore: Math.min(100, route.safetyScore + Math.random() * 2 - 1)
      })));
    }, 30000);

    return () => clearInterval(interval);
  }, [nearbyRoutes]);

  const updateArrivalTime = (currentTime: string) => {
    const [minutes] = currentTime.split(' ');
    const newMinutes = Math.max(1, parseInt(minutes) - 1);
    return `${newMinutes} min`;
  };

  const getUserLocation = async () => {
    setIsLoading(true);
    try {
      const position = await new Promise<GeolocationPosition>((resolve, reject) => {
        navigator.geolocation.getCurrentPosition(resolve, reject);
      });
      
      const location: UserLocation = {
        lat: position.coords.latitude,
        lng: position.coords.longitude,
        address: "Tu ubicación actual"
      };
      
      setUserLocation(location);
      setOrigin(location.address);
      
      // Simular rutas cercanas
      const mockRoutes: BusRoute[] = [
        {
          id: '1',
          number: 'M1',
          name: 'Metro Línea 1',
          nextArrival: '3 min',
          safetyScore: 95,
          distance: 150,
          stops: ['Plaza Mayor', 'Universidad', 'Hospital Central'],
          realTimeUpdates: true
        },
        {
          id: '2',
          number: 'B47',
          name: 'Bus Expreso Centro',
          nextArrival: '7 min',
          safetyScore: 88,
          distance: 280,
          stops: ['Parque Central', 'Estación Norte', 'Terminal'],
          realTimeUpdates: true
        },
        {
          id: '3',
          number: 'T2',
          name: 'Tranvía Verde',
          nextArrival: '12 min',
          safetyScore: 92,
          distance: 420,
          stops: ['Eco Park', 'Ciudad Universitaria', 'Centro Comercial'],
          realTimeUpdates: false
        }
      ];
      
      setNearbyRoutes(mockRoutes);
    } catch (error) {
      console.error('Error obteniendo ubicación:', error);
    } finally {
      setIsLoading(false);
    }
  };

  const getSafetyColor = (score: number) => {
    if (score >= 90) return 'text-green-400';
    if (score >= 80) return 'text-yellow-400';
    return 'text-red-400';
  };

  const handleRouteSelect = (route: BusRoute) => {
    setSelectedRoute(route);
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-900 via-slate-800 to-slate-900 p-4">
      <div className="max-w-md mx-auto space-y-4">
        {/* Header */}
        <div className="glass-effect rounded-xl p-4 text-center">
          <h1 className="text-2xl font-bold transport-gradient bg-clip-text text-transparent">
            SafeTransit
          </h1>
          <p className="text-sm text-muted-foreground">Transporte público inteligente y seguro</p>
        </div>

        {/* Location Input */}
        <Card className="glass-effect border-white/20">
          <CardContent className="p-4 space-y-3">
            <div className="flex items-center space-x-2">
              <MapPin className="w-5 h-5 text-green-400" />
              <Input
                placeholder="Origen"
                value={origin}
                onChange={(e) => setOrigin(e.target.value)}
                className="bg-white/5 border-white/20"
              />
              <Button
                size="sm"
                variant="outline"
                onClick={getUserLocation}
                disabled={isLoading}
                className="border-white/20 hover:bg-white/10"
              >
                <Navigation className="w-4 h-4" />
              </Button>
            </div>
            
            <div className="flex items-center space-x-2">
              <MapPin className="w-5 h-5 text-blue-400" />
              <Input
                placeholder="Destino"
                value={destination}
                onChange={(e) => setDestination(e.target.value)}
                className="bg-white/5 border-white/20"
              />
            </div>
          </CardContent>
        </Card>

        {/* Routes List */}
        {nearbyRoutes.length > 0 && (
          <div className="space-y-3">
            <h3 className="text-lg font-semibold text-white flex items-center">
              <Clock className="w-5 h-5 mr-2 text-blue-400" />
              Rutas cercanas
            </h3>
            
            {nearbyRoutes.map((route) => (
              <Card
                key={route.id}
                className={`glass-effect border-white/20 cursor-pointer transition-all hover:bg-white/15 ${
                  selectedRoute?.id === route.id ? 'ring-2 ring-blue-400' : ''
                }`}
                onClick={() => handleRouteSelect(route)}
              >
                <CardContent className="p-4">
                  <div className="flex items-center justify-between mb-2">
                    <div className="flex items-center space-x-3">
                      <Badge className="transport-gradient text-white font-bold">
                        {route.number}
                      </Badge>
                      <span className="font-medium text-white">{route.name}</span>
                      {route.realTimeUpdates && (
                        <Zap className="w-4 h-4 text-yellow-400 safety-pulse" />
                      )}
                    </div>
                    <div className="text-right">
                      <div className="text-sm font-semibold text-green-400">
                        {route.nextArrival}
                      </div>
                      <div className="text-xs text-muted-foreground">
                        {route.distance}m
                      </div>
                    </div>
                  </div>
                  
                  <div className="flex items-center justify-between">
                    <div className="flex items-center space-x-2">
                      <Shield className={`w-4 h-4 ${getSafetyColor(route.safetyScore)}`} />
                      <span className={`text-sm font-medium ${getSafetyColor(route.safetyScore)}`}>
                        Seguridad: {route.safetyScore.toFixed(1)}%
                      </span>
                    </div>
                    <div className="text-xs text-muted-foreground">
                      {route.stops.length} paradas
                    </div>
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>
        )}

        {/* Payment Options */}
        <div className="grid grid-cols-2 gap-3">
          <Button
            onClick={() => setShowPayment(true)}
            className="glass-effect border-white/20 hover:bg-white/20 h-16 flex flex-col items-center justify-center space-y-1"
            variant="outline"
          >
            <div className="w-6 h-6 rounded-full bg-blue-500 flex items-center justify-center">
              <span className="text-xs font-bold text-white">NFC</span>
            </div>
            <span className="text-xs">Pago NFC</span>
          </Button>
          
          <Button
            onClick={() => setShowQRScanner(true)}
            className="glass-effect border-white/20 hover:bg-white/20 h-16 flex flex-col items-center justify-center space-y-1"
            variant="outline"
          >
            <QrCode className="w-6 h-6" />
            <span className="text-xs">Escanear QR</span>
          </Button>
        </div>

        {/* Route Optimizer */}
        {selectedRoute && destination && (
          <RouteOptimizer 
            selectedRoute={selectedRoute}
            destination={destination}
            userLocation={userLocation}
          />
        )}

        {/* Safety Analytics */}
        <SafetyAnalytics routes={nearbyRoutes} />

        {/* Payment Modals */}
        {showPayment && (
          <NFCPayment onClose={() => setShowPayment(false)} />
        )}
        
        {showQRScanner && (
          <QRScanner onClose={() => setShowQRScanner(false)} />
        )}
      </div>
    </div>
  );
};

export default TransportApp;
