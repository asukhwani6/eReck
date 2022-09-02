figure
thermalmodel = createpde('thermal','transient');
% geometryFromEdges(thermalmodel,@crackgModified);
geometryFromEdges(thermalmodel,@crackgTest);

pdegplot(thermalmodel,'EdgeLabels','on','FaceLabels','on')
ylim([-0.01,0.1])

thermalProperties(thermalmodel,'ThermalConductivity',237,...
                               'MassDensity',2710,...
                               'SpecificHeat',903);

thermalBC(thermalmodel,'Edge',2,'ConvectionCoefficient',125,'AmbientTemperature',60); % Implement equivelant heat transfer coefficient
for i = [1,5,6,7,9,10]
thermalBC(thermalmodel,'Edge',i,'HeatFlux',0);
end

for i = [3,4,8]
thermalBC(thermalmodel,'Edge',i, ...
                'ConvectionCoefficient',1000, ...
                'AmbientTemperature',30);
% thermalBC(thermalmodel,'Edge',3,'Temperature',30);
end
thermalIC(thermalmodel,30);

generateMesh(thermalmodel,'Hmax',0.001)
figure
pdemesh(thermalmodel)
title('Mesh with Quadratic Triangular Elements')
ylabel('Z Position (m)')
xlabel('Y Position (m)')
axis normal
ylim([-0.01,0.05])

tlist = 0:1:500;

thermalresults = solve(thermalmodel,tlist);
% thermalresults = solve(thermalmodel);

[qx,qy] = evaluateHeatFlux(thermalresults);
figure
pdeplot(thermalmodel,'XYData',thermalresults.Temperature(:,end), ...
                     'Contour','on')
%                    'FlowData',[qx(:,end),qy(:,end)], ...
axis normal
ylabel('Z Position (m)')
xlabel('Y Position (m)')
title('Steady State 2D Cross Sectional Heat Transfer','150W at Lower Surface, Constant Temperature at Cooling Channel')
ylim([-0.01,0.05])

%% Simulation Animation

nframes = numel(thermalresults.SolutionTimes);
delay = 0.01;

 for i = 1:nframes
        h = pdeplot(thermalmodel,'XYData',thermalresults.Temperature(:,i));
        set(gcf,'units','normalized','outerposition',[0 0 1 1]);
        delete(findall(gca,'type','quiver'));
        qt = findall(gca,'type','text');
        pause(delay);
 end