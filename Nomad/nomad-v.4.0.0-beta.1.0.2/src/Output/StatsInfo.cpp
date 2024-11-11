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
/**
 * \file   StatsInfo.cpp
 * \brief  Class for Stats info and display
 * \author Viviane Rochon Montplaisir, Christophe Tribes
 * \date   February 2018
 */

#include "../Output/StatsInfo.hpp"
#include "../Util/fileutils.hpp"

// Constructor 1
NOMAD::StatsInfo::StatsInfo()
  : _obj(),
    _consH(),
    _hMax(),
    _bbe(0),
    _algoBBE(0),
    _blkEva(0),
    _blkSize(0),
    _bbo(),
    _eval(0),
    _cacheHits(0),
    _time(0),
    _meshIndex(),
    _meshSize(),
    _frameSize(),
    _lap(0),
    _sgte(0),
    _totalSgte(0),
    _sol(),
    _threadNum(0),
    _relativeSuccess(false),
    _comment(""),
    _genStep("")
{
}


bool NOMAD::StatsInfo::alwaysDisplay(const bool displayInfeasible, const bool displayUnsuccessful) const
{
    bool doDisplay = false;
    if (!_obj.isDefined())
    {
        doDisplay = false;
    }
    else if (_bbe <= 1) 
    {
        // Always display X0 evaluation
        doDisplay = true;
    }
    else if (displayInfeasible || (_consH.isDefined() && _consH == 0.0))
    {
        if (displayUnsuccessful || _relativeSuccess)
        {
            doDisplay = true;
        }
    }

    return doDisplay;
}


// Convert a string like "BBE", "BBO", "OBJ", "SOL", "TIME"... to
// the corresponding NOMAD::DisplayStatsType.
// "%"
NOMAD::DisplayStatsType NOMAD::StatsInfo::stringToDisplayStatsType(const std::string& inputStr, std::string& format)
{
    NOMAD::DisplayStatsType ret;
    std::string s = inputStr;

    std::string tag;
    if (NOMAD::separateFormat(s, format, tag))
    {
        s = tag;
    }

    NOMAD::toupper(s);

    if (s == "OBJ")
    {
        ret = NOMAD::DisplayStatsType::DS_OBJ;
    }
    else if (s == "CONS_H")
    {
        ret = NOMAD::DisplayStatsType::DS_CONS_H;
    }
    else if (s == "H_MAX")
    {
        ret = NOMAD::DisplayStatsType::DS_H_MAX;
    }
    else if (s == "BBE")
    {
        ret = NOMAD::DisplayStatsType::DS_BBE;
    }
    else if (s == "ALGO_BBE")
    {
        ret = NOMAD::DisplayStatsType::DS_ALGO_BBE;
    }
    else if (s == "BLK_EVA")
    {
        ret = NOMAD::DisplayStatsType::DS_BLK_EVA;
    }
    else if (s == "BLK_SIZE")
    {
        ret = NOMAD::DisplayStatsType::DS_BLK_SIZE;
    }
    else if (s == "BBO")
    {
        ret = NOMAD::DisplayStatsType::DS_BBO;
    }
    else if (s == "EVAL")
    {
        ret = NOMAD::DisplayStatsType::DS_EVAL;
    }
    else if (s == "CACHE_HITS")
    {
        ret = NOMAD::DisplayStatsType::DS_CACHE_HITS;
    }
    else if (s == "TIME")
    {
        ret = NOMAD::DisplayStatsType::DS_TIME;
    }
    else if (s == "MESH_INDEX")
    {
        ret = NOMAD::DisplayStatsType::DS_MESH_INDEX;
    }
    else if (s == "MESH_SIZE" || s == "DELTA_M")
    {
        ret = NOMAD::DisplayStatsType::DS_MESH_SIZE;
    }
    // POLL_SIZE and DELTA_P are for backwards compatibility.
    else if (s == "FRAME_SIZE" || s == "DELTA_F" || s == "POLL_SIZE" || s == "DELTA_P")
    {
        ret = NOMAD::DisplayStatsType::DS_FRAME_SIZE;
    }
    else if (s == "LAP")
    {
        ret = NOMAD::DisplayStatsType::DS_LAP;
    }
    else if (s == "SGTE")
    {
        ret = NOMAD::DisplayStatsType::DS_SGTE;
    }
    else if (s == "SOL")
    {
        ret = NOMAD::DisplayStatsType::DS_SOL;
    }
    else if (s == "THREAD_NUM")
    {
        ret = NOMAD::DisplayStatsType::DS_THREAD_NUM;
    }
    else if (s == "GEN_STEP")
    {
        ret = NOMAD::DisplayStatsType::DS_GEN_STEP;
    }
    else if (s == "TOTAL_SGTE")
    {
        ret = NOMAD::DisplayStatsType::DS_TOTAL_SGTE;
    }
    else
    {
        // Don't throw an exception.
        // Any string is accepted for output, for instance parenthesis
        // around the SOL, free text, etc.
        // If some string should be rejected, then the type
        // DS_UNDEFINED could be used.
        ret = NOMAD::DisplayStatsType::DS_USER;
    }

    return ret;
}


std::string NOMAD::StatsInfo::displayStatsTypeToString(const NOMAD::DisplayStatsType& displayStatsType)
{
    switch(displayStatsType)
    {
        case NOMAD::DisplayStatsType::DS_OBJ:
            return "OBJ";
        case NOMAD::DisplayStatsType::DS_CONS_H:
            return "CONS_H";
        case NOMAD::DisplayStatsType::DS_H_MAX:
            return "H_MAX";
        case NOMAD::DisplayStatsType::DS_BBE:
            return "BBE";
        case NOMAD::DisplayStatsType::DS_ALGO_BBE:
            return "ALGO_BBE";
        case NOMAD::DisplayStatsType::DS_BLK_EVA:
            return "BLK_EVA";
        case NOMAD::DisplayStatsType::DS_BLK_SIZE:
            return "BLK_SIZE";
        case NOMAD::DisplayStatsType::DS_BBO:
            return "BBO";
        case NOMAD::DisplayStatsType::DS_EVAL:
            return "EVAL";
        case NOMAD::DisplayStatsType::DS_CACHE_HITS:
            return "CACHE_HITS";
        case NOMAD::DisplayStatsType::DS_TIME:
            return "TIME";
        case NOMAD::DisplayStatsType::DS_MESH_INDEX:
            return "MESH_INDEX";
        case NOMAD::DisplayStatsType::DS_MESH_SIZE:
            return "MESH_SIZE";
        case NOMAD::DisplayStatsType::DS_DELTA_M:
            return "DELTA_M";
        case NOMAD::DisplayStatsType::DS_FRAME_SIZE:
            return "FRAME_SIZE";
        case NOMAD::DisplayStatsType::DS_DELTA_F:
            return "DELTA_F";
        case NOMAD::DisplayStatsType::DS_LAP:
            return "LAP";
        case NOMAD::DisplayStatsType::DS_SGTE:
            return "SGTE";
        case NOMAD::DisplayStatsType::DS_SOL:
            return "SOL";
        case NOMAD::DisplayStatsType::DS_THREAD_NUM:
            return "THREAD_NUM";
        case NOMAD::DisplayStatsType::DS_GEN_STEP:
            return "GEN_STEP";
        case NOMAD::DisplayStatsType::DS_TOTAL_SGTE:
            return "TOTAL_SGTE";
        case NOMAD::DisplayStatsType::DS_USER:
            return "USER";
        case NOMAD::DisplayStatsType::DS_UNDEFINED:
        default:
            return "UNDEFINED";
    }
}


std::string NOMAD::StatsInfo::display(const NOMAD::DisplayStatsTypeList& format,
                                      const NOMAD::ArrayOfDouble & solFormat,
                                      const size_t objWidth,
                                      const size_t hWidth,
                                      const bool starSuccess,
                                      const bool appendComment) const
{
    std::string out;

    // Special case: an empty string will display BBE and OBJ.
    if (format.empty())
    {
        return display(NOMAD::DisplayStatsTypeList("BBE OBJ"), solFormat, objWidth);
    }

    // Compute precision. Precision of OBJ is the maximum precision of solFormat.
    int objPrec = 0;    // no decimals
    int hPrec = -1;     // free format
    if (solFormat.isDefined())
    {
        // We are ready to live with a wrong cast
        objPrec = static_cast<int>(solFormat.max().todouble());
        if (hWidth <= objWidth)
        {
            hPrec = objPrec;
        }
    }

    // Display selected types.
    NOMAD::DisplayStatsType statsType;
    for (size_t i = 0; i < format.size(); i++)
    {
        if (i > 0)
        {
            // Add a tab before pStart "(" or after pEnd ")".
            bool addTab = ( format[i-1] == NOMAD::ArrayOfDouble::pEnd
                           || format[i] == NOMAD::ArrayOfDouble::pStart );
            out += (addTab) ? "\t" : " ";
        }

        std::string doubleFormat;
        statsType = stringToDisplayStatsType(format[i], doubleFormat);

        if (NOMAD::DisplayStatsType::DS_OBJ == statsType)
        {
            if (doubleFormat.empty())
            {
                // Width is objWidth.
                out += _obj.display(objPrec, objWidth);
            }
            else
            {
                // doubleFormat overrides formatting
                out += _obj.display(doubleFormat);
            }
        }
        else if (NOMAD::DisplayStatsType::DS_CONS_H == statsType)
        {
            if (doubleFormat.empty())
            {
                // Width is hWidth. Use hPrec for precision.
                out += _consH.display(hPrec, hWidth);
            }
            else
            {
                // doubleFormat overrides formatting
                out += _consH.display(doubleFormat);
            }
        }
        else if (NOMAD::DisplayStatsType::DS_H_MAX == statsType)
        {
            if (doubleFormat.empty())
            {
                // Width is hWidth. Use hPrec for precision.
                out += _hMax.display(hPrec, hWidth);
            }
            else
            {
                // doubleFormat overrides formatting
                out += _hMax.display(doubleFormat);
            }
        }
        else if (NOMAD::DisplayStatsType::DS_BBE == statsType)
        {
            out += NOMAD::itos(_bbe);
        }
        else if (NOMAD::DisplayStatsType::DS_ALGO_BBE == statsType)
        {
            out += NOMAD::itos(_algoBBE);
        }
        else if (NOMAD::DisplayStatsType::DS_BLK_EVA == statsType)
        {
            out += NOMAD::itos(_blkEva);
        }
        else if (NOMAD::DisplayStatsType::DS_BLK_SIZE == statsType)
        {
            out += NOMAD::itos(_blkSize);
        }
        else if (NOMAD::DisplayStatsType::DS_BBO == statsType)
        {
            out += _bbo;
        }
        else if (NOMAD::DisplayStatsType::DS_EVAL == statsType)
        {
            out += NOMAD::itos(_eval);
        }
        else if (NOMAD::DisplayStatsType::DS_CACHE_HITS == statsType)
        {
            out += NOMAD::itos(_cacheHits);
        }
        else if (NOMAD::DisplayStatsType::DS_TIME == statsType)
        {
            out += NOMAD::itos(_time);
        }
        else if (NOMAD::DisplayStatsType::DS_MESH_INDEX == statsType)
        {
            out += _meshIndex.display(solFormat);
        }
        else if (NOMAD::DisplayStatsType::DS_MESH_SIZE == statsType
                 || NOMAD::DisplayStatsType::DS_DELTA_M == statsType)
        {
            out += _meshSize.display(solFormat);
        }
        else if (NOMAD::DisplayStatsType::DS_FRAME_SIZE == statsType
                 || NOMAD::DisplayStatsType::DS_DELTA_F == statsType)
        {
            out += _frameSize.display(solFormat);
        }
        else if (NOMAD::DisplayStatsType::DS_LAP == statsType)
        {
            out += NOMAD::itos(_lap);
        }
        else if (NOMAD::DisplayStatsType::DS_SGTE == statsType)
        {
            out += NOMAD::itos(_sgte);
        }
        else if (NOMAD::DisplayStatsType::DS_SOL == statsType)
        {
            // Here, use displayNoPar() to have the same output as NOMAD 3
            // (no additional parenthesis).
            out += _sol.displayNoPar(solFormat);
        }
        else if (NOMAD::DisplayStatsType::DS_THREAD_NUM == statsType)
        {
            out += NOMAD::itos(_threadNum);
        }
        else if (NOMAD::DisplayStatsType::DS_GEN_STEP == statsType)
        {
            out += _genStep;
        }
        else if (NOMAD::DisplayStatsType::DS_TOTAL_SGTE == statsType)
        {
            out += NOMAD::itos(_totalSgte);
        }
        else if (NOMAD::DisplayStatsType::DS_USER == statsType)
        {
            // Display original string
            out += (format[i]);
        }
        else if (NOMAD::DisplayStatsType::DS_UNDEFINED == statsType)
        {
            // Undefined type
            out += "UNDEFINED";
        }
        else
        {
            // Exception here - we should not be there,
            // unless we added a new DisplayStatsType and forgot
            // to update this function.
            throw NOMAD::Exception(__FILE__, __LINE__, "Unrecognized stats type");
        }

    }

    if (appendComment && !_comment.empty())
    {
        // Append comment if it is non-empty.
        out += " " + _comment;
    }

    if (starSuccess)
    {
        // Add an '*' if this evaluation was a success relative to the previous
        // evaluation, or relative to the mesh center if there was no previous
        // evaluation in the same pass.
        if (_relativeSuccess)
        {
            out += " *";
        }
    }

    return out;
}


std::string NOMAD::StatsInfo::displayHeader(const NOMAD::DisplayStatsTypeList& header,
                                            const NOMAD::ArrayOfDouble & solFormat,
                                            const size_t objWidth) const
{
    std::string out;

    // Do not display formatting. Separate it from the DisplayStatsType.
    NOMAD::DisplayStatsTypeList realHeader;
    for (size_t i = 0; i < header.size(); i++)
    {
        std::string format, dst;
        NOMAD::separateFormat(header[i], format, dst);
        realHeader.add(dst);
    }

    // Display header for selected types.
    // Keep it simple for now. Ideally, the headers would align with the fields.
    out += realHeader.display();

    return out;
}


