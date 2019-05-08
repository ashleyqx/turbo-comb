addpath('pathfcns');
Generate_Data;

%% Setup for solver
data=struct();
data.sn = Vn;                            % input signal
data.dt = dt;                            % input timestep

% Required parameters
param=struct();
param.fD_range = fDm*[0.75,1.25];        % Frequency range that the rep rate is known to be in.
                                         % If you don't know, get from abs(fft(Vn)).^2.
param.Q = [0.0419 0.000782 -0.00315 0.000438;0.000782 0.000146 -0.00199 -1.1e-05;-0.00315 -0.00199 0.328 -0.000572;0.000438 -1.1e-05 -0.000572 0.00056];
                                         % Process noise matrix (4x4)
                                         % If you don't know, set to diag([1,.01,1,.01].^2) and run EM
param.excess_noise = 2.76;               % Excess measurement noise factor
                                         % Code will calculate PSD near the Nyquist frequency and multiply by this to determine the noise.
                                         % If you don't know, set to 1 and run EM 

% Diagnostic parameters (used for plotting only). Helpful for simulated data.
% param.knownns = ns;                    
% param.knownA = As;
param.knownfD = fD;
param.knownf0 = f0;
param.knownp0 = p0;
param.knownpD = pD;
param.plotme  = 1;                       % Plot results?

% Other parameters. Don't change these unless you need to
param.initfrac = 0.1;                    % fraction of data to use for interferogram initialization procedure
param.Ninits = 2;                        % number of times to run interferogram initialization procedure
param.global_search_stds = 6;            % number of std devs to cover for global search
param.global_search_maxsize = 1e6;       % maximum on the global search num elements
param.EM = 1;                            % do an expectation maximization?

[sqrt(diag(param.Q)).',param.excess_noise,Inf]
oK=Augmented_Kalman(data,param);         % Run the filter!
Efficacy_Plots