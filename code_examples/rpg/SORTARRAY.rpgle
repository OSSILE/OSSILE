**FREE

///
// Sort Array on Substring of Array Entry
//
// This example shows how to sort an array on a substring of each array entry.
//
// In this example the data consists of postalcodes and corresponding city names.
// The array will be sorted by the postalcodes. The result will be displayed via
// the DSPLY command.
//
// \author Mihael Schmidt
// \date   2016-12-23
///


ctl-opt main(main) dftactgrp(*no) actgrp(*caller);


//-------------------------------------------------------------------------------------------------
// Prototypes
//-------------------------------------------------------------------------------------------------
dcl-pr main extpgm('SRTSUBARR') end-pr;


//-------------------------------------------------------------------------------------------------
// Program Entry Point
//-------------------------------------------------------------------------------------------------
dcl-proc main;
  dcl-ds *n;
    location char(50) dim(6);
    postalcode char(5) overlay(location);
    city char(45) overlay(location : *next);
  end-ds;

  // fill locations with test data
  location(1) = '32469Petershagen';
  location(2) = '32457Porta Westfalica';
  location(3) = '80000München';
  location(4) = '50667Köln';
  location(5) = '32425Minden';
  location(6) = '10965Berlin';

  // sort array on subkey (postalcode)
  sorta postalcode;

  // display sorted array
  dsply 'Cities sorted by postalcodes:';
  dsply location(1);
  dsply location(2);
  dsply location(3);
  dsply location(4);
  dsply location(5);
  dsply location(6);

end-proc;
