
import React, { useState, useEffect } from 'react';
import { X, Smartphone, CheckCircle, AlertCircle } from 'lucide-react';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';

interface NFCPaymentProps {
  onClose: () => void;
}

const NFCPayment: React.FC<NFCPaymentProps> = ({ onClose }) => {
  const [isScanning, setIsScanning] = useState(false);
  const [paymentStatus, setPaymentStatus] = useState<'idle' | 'scanning' | 'success' | 'error'>('idle');
  const [nfcSupported, setNfcSupported] = useState(false);

  useEffect(() => {
    // Verificar soporte NFC
    if ('NDEFReader' in window) {
      setNfcSupported(true);
    }
  }, []);

  const startNFCScan = async () => {
    setIsScanning(true);
    setPaymentStatus('scanning');

    try {
      if ('NDEFReader' in window) {
        const ndef = new (window as any).NDEFReader();
        await ndef.scan();
        
        // Simular proceso de pago
        setTimeout(() => {
          setPaymentStatus('success');
          setIsScanning(false);
          setTimeout(() => {
            onClose();
          }, 2000);
        }, 3000);
      } else {
        // Simular para navegadores sin NFC
        setTimeout(() => {
          setPaymentStatus('success');
          setIsScanning(false);
          setTimeout(() => {
            onClose();
          }, 2000);
        }, 2000);
      }
    } catch (error) {
      console.error('Error NFC:', error);
      setPaymentStatus('error');
      setIsScanning(false);
    }
  };

  const getStatusIcon = () => {
    switch (paymentStatus) {
      case 'scanning':
        return <Smartphone className="w-12 h-12 text-blue-400 animate-pulse" />;
      case 'success':
        return <CheckCircle className="w-12 h-12 text-green-400" />;
      case 'error':
        return <AlertCircle className="w-12 h-12 text-red-400" />;
      default:
        return <Smartphone className="w-12 h-12 text-white" />;
    }
  };

  const getStatusMessage = () => {
    switch (paymentStatus) {
      case 'scanning':
        return 'Acerca tu tarjeta o dispositivo...';
      case 'success':
        return '¡Pago procesado exitosamente!';
      case 'error':
        return 'Error en el pago. Inténtalo de nuevo.';
      default:
        return 'Toca para activar el pago NFC';
    }
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
          <CardTitle className="text-white">Pago NFC</CardTitle>
          {nfcSupported && (
            <Badge variant="outline" className="border-green-400 text-green-400 w-fit mx-auto">
              NFC Disponible
            </Badge>
          )}
        </CardHeader>
        
        <CardContent className="text-center space-y-6">
          <div className="flex flex-col items-center space-y-4">
            {getStatusIcon()}
            <p className="text-white text-lg font-medium">
              {getStatusMessage()}
            </p>
          </div>

          <div className="space-y-3">
            <div className="glass-effect rounded-lg p-3">
              <div className="flex justify-between text-sm">
                <span className="text-muted-foreground">Tarifa:</span>
                <span className="text-white font-medium">$2.50</span>
              </div>
            </div>

            {paymentStatus === 'idle' && (
              <Button
                onClick={startNFCScan}
                disabled={isScanning}
                className="w-full transport-gradient text-white font-medium"
              >
                {isScanning ? 'Escaneando...' : 'Iniciar Pago NFC'}
              </Button>
            )}

            {paymentStatus === 'error' && (
              <Button
                onClick={startNFCScan}
                className="w-full bg-red-600 hover:bg-red-700 text-white"
              >
                Reintentar Pago
              </Button>
            )}
          </div>

          <div className="text-xs text-muted-foreground space-y-1">
            <p>• Mantén tu dispositivo cerca del lector</p>
            <p>• El pago se procesará automáticamente</p>
            <p>• Compatible con tarjetas contactless</p>
          </div>
        </CardContent>
      </Card>
    </div>
  );
};

export default NFCPayment;
