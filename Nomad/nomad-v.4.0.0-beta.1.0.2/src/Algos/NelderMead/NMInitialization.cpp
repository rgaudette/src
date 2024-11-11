/*---------------------------------------------------------------------------------*/
/*  NOMAD - Nonlinear Optimization by Mesh Adaptive Direct Search -                */
/*                                                                                 */
/*  NOMAD - Version 4.0.0 has been created by                                      */
/*                 Viviane Rochon Montplaisir  - Polytechnique Montreal            */
/*                 Christophe Tribes           - Polytechnique Montreal            */
/*                                                                                 */
/*  The copyright of NOMAD - version 4.0.0 is owned by                             */
/*                 Sebastien Le Digabel        - Polytechnique Montreal            */
/*                 Viviane Rochon Montplaisir  - Polytechnique Montreal            */
/*                 Christophe Tribes           - Polytechnique Montreal            */
/*                                                                                 */
/*  NOMAD v4 has been funded by Rio Tinto, Hydro-Québec, NSERC (Natural Science    */
/*  and Engineering Research Council of Canada), INOVEE (Innovation en Energie     */
/*  Electrique and IVADO (The Institute for Data Valorization)                     */
/*                                                                                 */
/*  NOMAD v3 was created and developed by Charles Audet, Sebastien Le Digabel,     */
/*  Christophe Tribes and Viviane Rochon Montplaisir and was funded by AFOSR       */
/*  and Exxon Mobil.                                                               */
/*                                                                                 */
/*  NOMAD v1 and v2 were created and developed by Mark Abramson, Charles Audet,    */
/*  Gilles Couture, and John E. Dennis Jr., and were funded by AFOSR and           */
/*  Exxon Mobil.                                                                   */
/*                                                                                 */
/*  Contact information:                                                           */
/*    Polytechnique Montreal - GERAD                                               */
/*    C.P. 6079, Succ. Centre-ville, Montreal (Quebec) H3C 3A7 Canada              */
/*    e-mail: nomad@gerad.ca                                                       */
/*    phone : 1-514-340-6053 #6928                                                 */
/*    fax   : 1-514-340-5665                                                       */
/*                                                                                 */
/*  This program is free software: you can redistribute it and/or modify it        */
/*  under the terms of the GNU Lesser General Public License as published by       */
/*  the Free Software Foundation, either version 3 of the License, or (at your     */
/*  option) any later version.                                                     */
/*                                                                                 */
/*  This program is distributed in the hope that it will be useful, but WITHOUT    */
/*  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or          */
/*  FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License    */
/*  for more details.                                                              */
/*                                                                                 */
/*  You should have received a copy of the GNU Lesser General Public License       */
/*  along with this program. If not, see <http://www.gnu.org/licenses/>.           */
/*                                                                                 */
/*  You can find information on the NOMAD software at www.gerad.ca/nomad           */
/*---------------------------------------------------------------------------------*/

#include "../../Algos/CacheInterface.hpp"
#include "../../Algos/EvcInterface.hpp"

#include "../../Algos/NelderMead/NMInitialization.hpp"


void NOMAD::NMInitialization::init()
{
    _name = getAlgoName() + "Initialization";
    
    _nmStopReason = NOMAD::AlgoStopReasons<NOMAD::NMStopType>::get( _stopReasons );
}


bool NOMAD::NMInitialization::runImp()
{
    bool doContinue = ! _stopReasons->checkTerminate();
    
    if (doContinue)
    {
        // For a standalone NM, evaluate the trial points generated during start (simplex is created later)
        // Otherwise, there are no trial points available
        evalTrialPoints(this);
        doContinue = ! _stopReasons->checkTerminate();
        if ( ! doContinue )
            _nmStopReason->set(NOMAD::NMStopType::INITIAL_FAILED);

    }
    return doContinue;
}

void NOMAD::NMInitialization::startImp()
{
    
    if ( ! _stopReasons->checkTerminate() )
    {
        // If needed, generate trial points and put them in cache to form simplex
        // For a standalone optimization (NM_OPTIMIZATION true), initial trial points must be generated to form a valid simplex around x0. Otherwise, the cache will be used to construct the simplex.
        auto nm_opt = _runParams->getAttributeValue<bool>("NM_OPTIMIZATION");
        if ( nm_opt && ! checkCacheCanFormSimplex() )
        {
            generateTrialPoints();
        }
    }
    
}

bool NOMAD::NMInitialization::checkCacheCanFormSimplex()
{
    size_t n = _pbParams->getAttributeValue<size_t>("DIMENSION");
    if ( NOMAD::CacheBase::getInstance()->size() < n+1 )
        return false;
    // TODO
    return false;
        
}

// Generate trial points to form a simplex
void NOMAD::NMInitialization::generateTrialPoints()
{
    NOMAD::Point x0 = _pbParams->getAttributeValue<NOMAD::Point>("X0");
    size_t n = _pbParams->getAttributeValue<size_t>("DIMENSION");

    if (!x0.isComplete() || x0.size() != n)
    {
        std::string err = "Initialization: evalY0: Invalid X0 " + x0.display();
        size_t cacheSize = NOMAD::CacheBase::getInstance()->size();
        if (cacheSize > 0)
        {
            err += ". Hint: Try not setting X0 so that the cache is used (";
            err += std::to_string(cacheSize) + " points)";
        }
        else
        {
            err += ". Cache is empty.";
        }
        throw NOMAD::Exception(__FILE__, __LINE__, err);
    }

    NOMAD::EvalPoint evalPoint_x0(x0);
    insertTrialPoint(evalPoint_x0);
    AddOutputInfo("Using X0: " + evalPoint_x0.display());
    
    // Method to generate simplex points using X0 adapted from fminsearch (matlab)
    const NOMAD::Double usualDelta = 0.05;    //  x0 + 5 percent
    const NOMAD::Double zeroDelta = 0.00025;  //
    for ( size_t j = 0 ; j < n ; j++ )
    {
        NOMAD::EvalPoint trialPoint(x0);
        if ( trialPoint[j] != 0 )
            trialPoint[j] *= (1 + usualDelta );
        else
            trialPoint[j] = zeroDelta;
        
        insertTrialPoint(trialPoint);
    }

    NOMAD::OutputQueue::Flush();
}

