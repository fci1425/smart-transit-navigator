
import React, { useState } from 'react';
import { X, Camera, CheckCircle, QrCode } from 'lucide-react';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';

interface QRScannerProps {
  onClose: () => void;
}

const QRScanner: React.FC<QRScannerProps> = ({ onClose }) => {
  const [isScanning, setIsScanning] = useState(false);
  const [scanResult, setScanResult] = useState<string | null>(null);

  const startScanning = () => {
    setIsScanning(true);
    
    // Simular escaneo de QR
    setTimeout(() => {
      setScanResult('TRANSPORT_QR_PAYMENT_SUCCESS_2024');
      setIsScanning(false);
      
      setTimeout(() => {
        onClose();
      }, 2000);
    }, 3000);
  };

  return (
    <div className="fixed inset-0 bg-black/80 flex items-center justify-center p-4 z-50">
      <Card className="glass-effect border-white/20 w-full max-w-sm">
        <CardHeader className="text-center relative">
          <Button
            variant="ghost"
            size="sm"
            onClick={onClose}
            className="absolute right-2 top-2 text-white hover:bg-white/20"
          >
            <X className="w-4 h-4" />
          </Button>
          <CardTitle className="text-white">Escanear QR</CardTitle>
        </CardHeader>
        
        <CardContent className="text-center space-y-6">
          <div className="relative">
            <div className="aspect-square bg-black/50 rounded-lg border-2 border-dashed border-white/30 flex items-center justify-center">
              {!isScanning && !scanResult && (
                <div className="text-center space-y-3">
                  <QrCode className="w-16 h-16 text-white/50 mx-auto" />
                  <p className="text-white/70">Presiona para escanear</p>
                </div>
              )}
              
              {isScanning && (
                <div className="text-center space-y-3">
                  <Camera className="w-16 h-16 text-blue-400 mx-auto animate-pulse" />
                  <p className="text-blue-400">Escaneando...</p>
                  <div className="w-32 h-32 border-2 border-blue-400 rounded-lg animate-pulse mx-auto"></div>
                </div>
              )}
              
              {scanResult && (
                <div className="text-center space-y-3">
                  <CheckCircle className="w-16 h-16 text-green-400 mx-auto" />
                  <p className="text-green-400 font-medium">¡Código escaneado!</p>
                </div>
              )}
            </div>
          </div>

          {!isScanning && !scanResult && (
            <Button
              onClick={startScanning}
              className="w-full transport-gradient text-white font-medium"
            >
              <Camera className="w-4 h-4 mr-2" />
              Activar Cámara
            </Button>
          )}

          <div className="space-y-2">
            <div className="glass-effect rounded-lg p-3">
              <div className="flex justify-between text-sm">
                <span className="text-muted-foreground">Tarifa:</span>
                <span className="text-white font-medium">$2.50</span>
              </div>
            </div>
          </div>

          <div className="text-xs text-muted-foreground space-y-1">
            <p>• Enfoca el código QR en el centro</p>
            <p>• Mantén el dispositivo estable</p>
            <p>• El pago se procesará automáticamente</p>
          </div>
        </CardContent>
      </Card>
    </div>
  );
};

export default QRScanner;
