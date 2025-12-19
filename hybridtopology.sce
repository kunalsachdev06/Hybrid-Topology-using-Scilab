clc;
clear;
clf();

// -----------------------------------------
// NODE COORDINATES
// -----------------------------------------

// Bus topology (9 nodes)
bus_x = [100 150 200 250 300 350 400 450 500];
bus_y = [500 500 500 500 500 500 500 500 500];

// Ring topology (8 nodes)
ring_x = [650 700 750 700 650 600 600 650];
ring_y = [600 650 600 550 500 550 600 650];

// Star topology (8 nodes)
star_x = [900 850 950 900 900 850 950 900];
star_y = [500 550 550 600 400 450 450 500];

// Combine all nodes
X = [bus_x ring_x star_x];
Y = [bus_y ring_y star_y];

n = length(X);   // Total nodes = 25

// -----------------------------------------
// EDGE LIST (Same logic as experiments)
// -----------------------------------------

edges = [];

// Bus edges
for i = 1:8
    edges = [edges; i i+1];
end

// Ring edges
for i = 10:16
    edges = [edges; i i+1];
end
edges = [edges; 17 10];   // Close ring

// Star edges (hub = node 18)
hub = 18;
for i = 19:25
    edges = [edges; hub i];
end

// Hybrid connections (EXP-11 logic)
edges = [edges;
         5 10;    // Bus → Ring
         14 18];  // Ring → Star hub

m = size(edges,1);   // Total edges

// -----------------------------------------
// DRAW TOPOLOGY (EXACT EXP STYLE)
// -----------------------------------------

plot(X, Y, 'o');
a = gca();
a.data_bounds = [0 0; 1000 1000];
xgrid();
xtitle("Hybrid Topology : Bus + Ring + Star", "X-Nodes", "Y-Nodes");

// Draw edges
for i = 1:m
    n1 = edges(i,1);
    n2 = edges(i,2);
    xpoly([X(n1) X(n2)], [Y(n1) Y(n2)]);
end

// -----------------------------------------
// NODE NUMBERING
// -----------------------------------------

for i = 1:n
    xstring(X(i)+8, Y(i)+8, string(i));
end

// -----------------------------------------
// EDGE NUMBERING
// -----------------------------------------

for i = 1:m
    n1 = edges(i,1);
    n2 = edges(i,2);
    xm = (X(n1)+X(n2))/2;
    ym = (Y(n1)+Y(n2))/2;
    xstring(xm, ym, string(i));
end

// -----------------------------------------
// NODE COLOURING (EXP-5 STYLE)
// -----------------------------------------

h = gce();              // Current entity
nodes = h.children;    // Node handles

// Bus nodes → Red
for i = 1:9
    nodes(i).foreground = 5;
end

// Ring nodes → Blue
for i = 10:17
    nodes(i).foreground = 2;
end

// Star nodes → Green
for i = 18:25
    nodes(i).foreground = 3;
end

// -----------------------------------------
// DEGREE CALCULATION
// -----------------------------------------

deg = zeros(1,n);

for i = 1:m
    deg(edges(i,1)) = deg(edges(i,1)) + 1;
    deg(edges(i,2)) = deg(edges(i,2)) + 1;
end

disp("Node Degrees:");
for i = 1:n
    disp("Node " + string(i) + " : " + string(deg(i)));
end

[maxdeg, node_max] = max(deg);
disp("Node with Maximum Degree: Node " + string(node_max));
disp("Maximum Degree = " + string(maxdeg));

// -----------------------------------------
// TOTAL COUNT
// -----------------------------------------

disp("Total Nodes = " + string(n));
disp("Total Edges = " + string(m));
